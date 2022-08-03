<?php

namespace App\Http\Controllers;

use App\Models\Post;
use App\Http\Resources\PostResource;
use App\Http\Requests\StorePostRequest;
use App\Http\Requests\UpdatePostRequest;

class PostsController extends Controller
{
    public function index()
    {
        return PostResource::collection(Post::all());
    }

    public function store(StorePostRequest $request)
    {
        $post = Post::create([
            'name' => $request->input('name'),
            'description' => $request->input('description'),
        ]);

        return new PostResource($post);
    }

    public function show(Post $post)
    {
        return new PostResource($post);
    }

    public function update(UpdatePostRequest $request, Post $post)
    {
        $post->update([
            'name' => $request->input('name'),
            'description' => $request->input('description')
        ]);
        $post->save();

        return new PostResource($post);
    }

    public function destroy(Post $post)
    {
        $post->delete();

        return response(null, 204);
    }
}
