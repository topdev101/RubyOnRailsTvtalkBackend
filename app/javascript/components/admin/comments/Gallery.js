
const Gallery = ({ images, videos }) => {
  return (
    <div style={{ display: 'flex' }}>
      {images?.map((image) => <img src={image} style={{ height: 100, padding: 5 }} />)}
      {videos?.map((video) => {
        return <video controls style={{ height: 100, padding: 5 }}>
          <source src={video} />
        </video>
      })}
    </div>
  )
}

export default Gallery;