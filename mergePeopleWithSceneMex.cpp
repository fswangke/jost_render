#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mex.h"
#include "matrix.h"

void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[]) {
        /*
         * Matlab usage example:
         * mergePeopleWithScene(scene_ply, vertex, faces, outname);
         */
        char* scene_ply_name;
        char* out_ply_name;
        char text[1000];
        size_t buflen_in;
        size_t buflen_out;
        int status;
        FILE* fin;
        FILE* fout;
        size_t len;
        size_t buf_size = 1000;

        buflen_in = mxGetN(prhs[0]) * sizeof(mxChar) + 1;
        scene_ply_name = (char*)mxMalloc(buflen_in);
        status = mxGetString(prhs[0], scene_ply_name, (mwSize)buflen_in);

        buflen_out = mxGetN(prhs[3]) * sizeof(mxChar) + 1;
        out_ply_name = (char*)mxMalloc(buflen_out);
        status = mxGetString(prhs[3], out_ply_name, (mwSize)buflen_out);

        fin = fopen(scene_ply_name, "r");
        if (fin == NULL) {
                mexPrintf("Cannot open file %s\n", scene_ply_name);
                return;
        }
        fout = fopen(out_ply_name, "w");
        if (fout == NULL) {
                mexPrintf("Cannot open file %s\n", out_ply_name);
                return;
        }

        /* remove header from input file */
        fgets(text, buf_size, fin);
        fgets(text, buf_size, fin);
        fgets(text, buf_size, fin);
        int vtxNum;
        int faceNum;
        fscanf(fin, "element vertex %d", &vtxNum);
        for (int i = 0; i < 8; ++i) {
                fgets(text, buf_size, fin);
        }
        fscanf(fin, "element face %d", &faceNum);
        mexPrintf("Scene vertex %d, face %d\n", vtxNum, faceNum);
        for (int i = 0; i < 3; ++i) {
                fgets(text, buf_size, fin);
        }

        // write header
        int vtxNum2 = mxGetM(prhs[1]);
        int faceNum2 = mxGetM(prhs[2]);

        fprintf(fout, "ply\n");
        fprintf(fout, "format ascii 1.0\n");
        fprintf(fout, "element vertex %d\n", vtxNum + vtxNum2);
        fprintf(fout, "property float x\n");
        fprintf(fout, "property float y\n");
        fprintf(fout, "property float z\n");
        fprintf(fout, "property uchar red\n");
        fprintf(fout, "property uchar green\n");
        fprintf(fout, "property uchar blue\n");
        fprintf(fout, "property uchar alpha\n");
        fprintf(fout, "element face %d\n", faceNum + faceNum2);
        fprintf(fout, "property list uchar int vertex_indices\n");
        fprintf(fout, "end_header\n");

        // write vertices
        for (int i = 0; i < vtxNum; ++i) {
                bzero(text, buf_size);
                fgets(text, buf_size, fin);
                fprintf(fout, "%s", text);
        }
        double* vtxPr = mxGetPr(prhs[1]);
        int vtxRow = mxGetM(prhs[1]);
        int vtxCol = mxGetN(prhs[1]);
        double* facePtr = mxGetPr(prhs[2]);
        int faceRow = mxGetM(prhs[2]);
        int faceCol = mxGetN(prhs[2]);
        for (int i = 0; i < vtxNum2; ++i) {
                fprintf(fout, "%f %f %f %d %d %d 255\n", vtxPr[vtxRow * 0 + i],
                        vtxPr[vtxRow * 1 + i], vtxPr[vtxRow * 2 + i],
                        (int)vtxPr[vtxRow * 3 + i], (int)vtxPr[vtxRow * 4 + i],
                        (int)vtxPr[vtxRow * 5 + i]);
        }
        // write faces
        for (int i = 0; i < faceNum; ++i) {
                bzero(text, buf_size);
                fgets(text, buf_size, fin);
                fprintf(fout, "%s", text);
        }

        for (int i = 0; i < faceNum2; ++i) {
                fprintf(fout, "3 %d %d %d\n",
                        (int)facePtr[faceRow * 0 + i] + vtxNum,
                        (int)facePtr[faceRow * 1 + i] + vtxNum,
                        (int)facePtr[faceRow * 2 + i] + vtxNum);
        }

        fclose(fin);
        fclose(fout);
        mxFree(out_ply_name);
        mxFree(scene_ply_name);
}
