import React, { Component, useState } from 'react'
import Lightbox from 'react-image-lightbox'
import 'react-image-lightbox/style.css' // This only needs to be imported once in your app

export function Gallery({ images: _images }: { images: string[] }) {
  const [isOpen, setIsOpen] = useState(false)
  const [index, setIndex] = useState(0)
  const images = _images.map((x) => `/upload/${x}`)

  return (
    <div>
      <div className="grid gap-2 grid-cols-2 lg:grid-cols-4">
        {images.map((x, index) => (
          <div key={x}>
            <img
              key={x}
              src={x}
              className="object-cover object-center"
              onClick={() => {
                setIsOpen(true)
                setIndex(index)
              }}
            />
          </div>
        ))}
      </div>
      {isOpen && (
        <Lightbox
          mainSrc={images[index]}
          nextSrc={images[(index + 1) % images.length]}
          prevSrc={images[(index + images.length - 1) % images.length]}
          onCloseRequest={() => setIsOpen(false)}
          onMovePrevRequest={() => {
            setIndex((index + images.length - 1) % images.length)
          }}
          onMoveNextRequest={() => {
            setIndex((index + 1) % images.length)
          }}
        />
      )}
    </div>
  )
}
