<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class PostResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => (string)$this->id,
            'type' => 'Posts',
            'attributes' => [
                'name' => $this->name,
                'description' => $this->description,
            ]
        ];
    }
}
