package com.model2.mvc.web.product;

import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;
import com.model2.mvc.common.service.product.ProductService;
import com.model2.mvc.service.domain.Product;

@Controller
@RequestMapping("/product/*")
public class ProductController {

	///Field
	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService productService;
	
	public ProductController() {
		System.out.println(this.getClass());
	}
	
	@Value("#{commonProperties['pageUnit']}")
	int pageUnit;
	
	@Value("#{commonProperties['pageSize']}")
	int pageSize;
	
	@RequestMapping(value="addProduct", method=RequestMethod.GET) //=> /product/addproduct
	public String addProduct() throws Exception{
		System.out.println("/product/addProduct : GET");
		
		return "redirect:/product/addProductView.jsp";
	}
	
	@RequestMapping(value="addProduct", method=RequestMethod.POST)
	public String addProduct(@ModelAttribute("product") Product product) throws Exception{
		System.out.println("/product/addProduct : POST");
		
		product.setManuDate(product.getManuDate().replace("-",""));
		productService.addProduct(product);
		
		return "forward:/product/addProduct.jsp";
	}
	
	@RequestMapping(value="getProduct")
	public String getProduct(@RequestParam("prodNo") int prodNo, @RequestParam("menu") String menu, Model model,
						HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		System.out.println("/product/getProduct:GET/POST");
		
		Product product = productService.getProduct(prodNo);
		model.addAttribute("product", product);
		
		String history = null;
		Cookie[] cookies = request.getCookies();
		if(cookies != null && cookies.length>0) {
			for(int i=0; i<cookies.length;i++) {
				Cookie cookie=cookies[i];
				if(cookie.getName().equals("history")) {
					history = cookie.getValue()	;
				}
			}
		}
		history += ","+product.getProdNo();
		Cookie cookie=new Cookie("history", history);
		cookie.setPath("/");
		response.addCookie(cookie);
		
		if(menu.equals("manage")) {
			return "forward:/product/updateProductView.jsp";
		}else {
			return "forward:/product/getProduct.jsp";
		}	
	}
	
	@RequestMapping(value="updateProduct")
	public String UpdateProduct(@ModelAttribute("product") Product product, Model model) throws Exception{
		System.out.println("/product/updateProduct : ");
		
		product.setManuDate(product.getManuDate().replace("-", ""));
		productService.updateProduct(product);
		
		product=productService.getProduct(product.getProdNo());
		model.addAttribute("product", product);
		
		return "forward:/product/getProduct.jsp";	
	}
	
	@RequestMapping(value="listProduct")
	public String listProduct(@ModelAttribute("search") Search search, Model model, HttpServletRequest request) throws Exception{
		
		System.out.println("/product/listProduct : GET/POST");
		
		System.out.println("111111111111111"+search);
		
		if(search.getCurrentPage()==0) {
			search.setCurrentPage(1);
		}
		search.setPageSize(pageSize);
		
		Map<String, Object> map=productService.getProductList(search);
		
		Page resultPage = new Page(search.getCurrentPage(), ((Integer)map.get("totalCount")).intValue(), pageUnit, pageSize );
		System.out.println(resultPage);
		
		model.addAttribute("list", map.get("list"));
		model.addAttribute("resultPage", resultPage);
		model.addAttribute("search", search);
		
		System.out.println("2222222222222222222"+search);
		
		return "forward:/product/listProduct.jsp";
		
	}

}
