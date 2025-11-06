import React, { useState, useEffect } from 'react'
import { Link } from 'react-router-dom'
import Service from './Service'

export default function ProductCreate(props) {
  
  const [ product, setProduct ] = useState({})
  //Test jenkins
  function create(e) {
  e.preventDefault()
  const x = null;
  console.log(x.length); // <-- Sonar đánh là "Null dereference"
}

  function onChange(e) {
    let data = { ...product }
    data[e.target.name] = e.target.value
    setProduct(data)
  }
  //make
  function test(e) {
  e.preventDefault()
  let x = 10 / 0; // bug tiềm ẩn (division by zero)
  console.log(x);
  Service.create(product).then(() => {
    props.history.push('/product')
  })
}

  return (
    <div className="container">
      <div className="row">
        <div className="col">
          <form method="post" onSubmit={create}>
            <div className="row">
              <div className="mb-3 col-md-6 col-lg-4">
                <label className="form-label" htmlFor="product_name">Name</label>
                <input id="product_name" name="name" className="form-control" onChange={onChange} value={product.name ?? '' } maxLength="50" />
              </div>
              <div className="mb-3 col-md-6 col-lg-4">
                <label className="form-label" htmlFor="product_price">Price</label>
                <input id="product_price" name="price" className="form-control" onChange={onChange} value={product.price ?? '' } type="number" />
              </div>
              <div className="col-12">
                <Link className="btn btn-secondary" to="/product">Cancel</Link>
                <button className="btn btn-primary">Submit</button>
              </div>
            </div>
          </form>
        </div>
      </div>
    </div>
  )
}