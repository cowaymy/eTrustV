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
	
	/**
	 * Customer 상세 조회 Address List 
	 * @param params
	 * @param model
	 * @return ResponseEntity
	 */
	@RequestMapping(value = "/selectCustomerAddressJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCustomerAddressJsonList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		List<EgovMap> addresslist = null;
		//TODO 추후 삭제
		params.put("testparam", 31);
		logger.info("##### customer Address Parsing START #####");
		addresslist = customerService.selectCustomerAddressJsonList(params);
		
		return ResponseEntity.ok(addresslist);
		
	}
	/**
	 * Customer 상세 조회 Contact List 
	 * @param params
	 * @param model
	 * @return ResponseEntity
	 */
	@RequestMapping(value = "/selectCustomerContactJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCustomerContactJsonList(@RequestParam Map<String, Object>params, ModelMap model)throws Exception{
		
		List<EgovMap> contactlist = null;
		//TODO 추후 삭제
		params.put("testparam", 31);
		logger.info("##### customer Contact Parsing START #####");
		contactlist = customerService.selectCustomerContactJsonList(params);
		// 데이터 리턴.
		return ResponseEntity.ok(contactlist);
		
	}
	/**
	 * 
	 * Customer View Bank List
	 * @param params
	 * @param model
	 * @return
	 * @author 이석희 2017.07.21
	 * */
	@RequestMapping(value = "/selectCustomerBankAccJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCustomerBankAccJsonList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		List<EgovMap> banklist = null;
		//TODO 추후 삭제
		params.put("testparam", 31);
		logger.info("##### customer Bank List Parsing START #####");
		banklist = customerService.selectCustomerBankAccJsonList(params);
		
		return ResponseEntity.ok(banklist);
		
	}
	/**
	 * 
	 * Customer View CreditCard List
	 * @param params
	 * @param model
	 * @return
	 * @author 이석희 2017.07.21
	 * */
	@RequestMapping(value = "/selectCustomerCreditCardJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCustomerCreditCardJsonList(@RequestParam Map<String, Object> params, ModelMap model)throws Exception{
		
		List<EgovMap> cardlist = null;
		//TODO 추후 삭제
		params.put("testparam",12);
		logger.info("##### customer Card List Parsing START #####");
		cardlist = customerService.selectCustomerCreditCardJsonList(params);
		
		return ResponseEntity.ok(cardlist);
		
	}
	/**
	 * 
	 * Customer View CreditCard List
	 * @param params
	 * @param model
	 * @return
	 * @author 이석희 2017.07.21
	 * */
	@RequestMapping(value = "/selectCustomerOwnOrderJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCustomerOwnOrderJsonList(@RequestParam Map<String, Object> params, ModelMap model)throws Exception{
		
		List<EgovMap> ownorderlist = null;
		//TODO 추후 삭제
		params.put("testparam", 12);
		logger.info("##### customer Own Order Parsing START #####");
		ownorderlist = customerService.selectCustomerOwnOrderJsonList(params);
		
		return ResponseEntity.ok(ownorderlist);
	}
	/**
	 * 
	 * Customer View 상세화면
	 * @param params
	 * @param model
	 * @return
	 * @author 이석희 2017.07.20
	 * */
	@RequestMapping(value = "/selectCustomerView.do")
	public String selectCustomerView(@RequestParam Map<String, Object> params, ModelMap model)throws Exception{
		
		EgovMap basicinfo = null;
		EgovMap addresinfo = null;
		EgovMap contactinfo = null;
		
		//TODO 추후 삭제
		//test param
		params.put("testparam",31);
		
		logger.info("##### customeView START #####");
		basicinfo = customerService.selectCustomerViewBasicInfo(params);
		addresinfo = customerService.selectCustomerViewMainAddress(params);
		contactinfo = customerService.selectCustomerViewMainContact(params);
		
		//TODO 추후 삭제
		if(basicinfo != null){
			logger.info("##### 결과값 확인 basicInfo : {}", basicinfo.toString() , "#####");
		}
		if(addresinfo != null){
			logger.info("##### 결과값 확인 addresinfo : {}", addresinfo.toString() , "#####");
		}
		if(contactinfo != null){
			logger.info("##### 결과값 확인 contactinfo : {}", contactinfo.toString() , "#####");
		}
		
		model.addAttribute("result", basicinfo);
		model.addAttribute("addresinfo", addresinfo);
		model.addAttribute("contactinfo", contactinfo);
		
		return "sales/customer/customerView";
	}
	
}
