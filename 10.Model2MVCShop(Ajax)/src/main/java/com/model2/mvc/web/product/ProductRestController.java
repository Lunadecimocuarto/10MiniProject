package com.model2.mvc.web.product;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.model2.mvc.common.Search;
import com.model2.mvc.common.service.product.ProductService;
import com.model2.mvc.service.domain.Product;

@RestController
@RequestMapping("/product/*")
public class ProductRestController {

	
	///Field
	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService productService;
	
	public ProductRestController() {
		System.out.println(this.getClass());
	}
	
	@Value("#{commonProperties['pageUnit']}")
	int pageUnit;
	
	@Value("#{commonProperties['pageSize']}")
	int pageSize;
	
	@RequestMapping(value="json/getProduct/{prodNo}",method=RequestMethod.GET)
	public Product getProduct(@PathVariable int prodNo) throws Exception{
		
		System.out.println("/product/json/getProduct:GET");
		Product product = productService.getProduct(prodNo);
		
		
		System.out.println(product);
		//business logic
		return productService.getProduct(prodNo);
	}
	
	@RequestMapping(value="json/addProduct",method=RequestMethod.POST)
	public Product addProduct(@RequestBody Product product) throws Exception{
		
		System.out.println("/product/json/addProduct:POST");
		productService.addProduct(product);
		
		return product;
	}
	
	@RequestMapping(value="json/updateProduct", method=RequestMethod.POST)
	public Product updateProduct(@RequestBody Product product) throws Exception{
		
		System.out.println("/product/json/updateProduct:POST");
		
		productService.updateProduct(product);
		
		product=productService.getProduct(product.getProdNo());
		
		return product;
	}
	
	@RequestMapping(value="json/listProduct")
	public String listProduct(Search search) throws Exception{
		
		return null;
	}

}
