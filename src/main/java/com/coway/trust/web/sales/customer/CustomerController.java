package com.coway.trust.web.sales.customer;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.biz.sales.customer.CustomerService;
import com.coway.trust.biz.sales.customer.CustomerVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/customer")
public class CustomerController {
	
	private static final Logger logger = LoggerFactory.getLogger(CustomerController.class);
	
	@Resource(name = "customerService")
	private CustomerService customerService;
	
	
	/**
	 * Customer List 초기화 화면 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectCustomerList.do")
	public String selectCustomerList(@ModelAttribute("customerVO") CustomerVO customerVO,
			@RequestParam Map<String, Object>params, ModelMap model){
		
		return "sales/customer/customerList";
	}
	
	
	/**
	 * Customer List 데이터조회 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/selectCustomerJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCustomerJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {
		
		List<EgovMap> customerList = null;
		
		String[] typeId = request.getParameterValues("cmbTypeId");						// Customer Type 콤보박스 값
		String[] cmbCorpTypeId = request.getParameterValues("cmbCorpTypeId");		// Company Type 콤보박스 값
		params.put("typeIdList", typeId);
		params.put("cmbCorpTypeIdList", cmbCorpTypeId);
		
		
		logger.info("##### customerList START #####");
		customerList = customerService.selectCustomerList(params);
		
		// 데이터 리턴.
		return ResponseEntity.ok(customerList);
		
	}

}
