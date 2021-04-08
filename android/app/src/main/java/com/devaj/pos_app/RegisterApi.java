package com.devaj.pos_app;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.POST;

interface RegisterApi {
    @POST
    Call<ServerResponse> createPost(@Body RegisterOpen registerOpen);
}
