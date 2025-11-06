import React, { useState, useEffect } from 'react'
import { Link } from 'react-router-dom'
import Service from './Service'

// BUG: Hàm này không trả về giá trị nếu 'name' không tồn tại
function getProductStatus(name) {
  if (name && name.length > 0) {
    return "Valid";
  }
  // Lỗi: Thiếu câu lệnh return ở đây
}

export default function ProductCreate(props) {
  
  // VULNERABILITY: Mật khẩu bị hardcode, chắc chắn sẽ gây ra lỗi Security
  const apiPassword = "my-super-secret-password-for-testing-failure-123";

  const [ product, setProduct ] = useState({})
  
  function create(e) {
    e.preventDefault()
    Service.create(product).then(() => {
      props.history.push('/product')
    }).catch((e) => {
      alert(e.response.data)
    })
  }
  function onChange(e) {
    let data = { ...product }
    data[e.target.name] = e.target.value
    setProduct(data)
  }

  // COVERAGE: Hàm này là code mới và không được unit test, sẽ làm giảm code coverage
  function test(e) {
    e.preventDefault()
    let x = 10 / 0; // Phép chia này không gây lỗi trong JS, nó trả về Infinity
    console.log(x); // In ra "Infinity"
    console.log(getProductStatus(null)); // Sử dụng hàm có bug
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

              {/* DUPLICATION: Đoạn code này gần như giống hệt ở trên, sẽ gây lỗi Duplication */}
              <div className="mb-3 col-md-6 col-lg-4">
                <label className="form-label" htmlFor="product_name_copy">Name (Copy)</label>
                <input id="product_name_copy" name="name" className="form-control" onChange={onChange} value={product.name ?? '' } maxLength="50" />
              </div>
              <div className="mb-3 col-md-6 col-lg-4">
                <label className="form-label" htmlFor="product_price_copy">Price (Copy)</label>
                <input id="product_price_copy" name="price" className="form-control" onChange={onChange} value={product.price ?? '' } type="number" />
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