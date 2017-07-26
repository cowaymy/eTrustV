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
		//params		
		params.put("custId", params.get("custId"));
		
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
		//params
		params.put("custId", params.get("custId"));
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
		//params
		params.put("custId", params.get("custId"));
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
		//params
		params.put("custId", params.get("custId"));
		logger.info("##### customer Card List Parsing START #####");
		cardlist = customerService.selectCustomerCreditCardJsonList(params);
		
		return ResponseEntity.ok(cardlist);
	}
	
	
	/**
	 * 
	 * Customer View Own Order List
	 * @param params
	 * @param model
	 * @return
	 * @author 이석희 2017.07.21
	 * */
	@RequestMapping(value = "/selectCustomerOwnOrderJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCustomerOwnOrderJsonList(@RequestParam Map<String, Object> params, ModelMap model)throws Exception{
		
		List<EgovMap> ownorderlist = null;
		//params
		params.put("custId", params.get("custId"));
		logger.info("##### customer Own Order Parsing START #####");
		ownorderlist = customerService.selectCustomerOwnOrderJsonList(params);
		
		return ResponseEntity.ok(ownorderlist);
	}
	
	
	/**
	 * 
	 * Customer View Third Party Order List
	 * @param params
	 * @param model
	 * @return
	 * @author 이석희 2017.07.21
	 * */
	@RequestMapping(value = "/selectCustomerThirdPartyJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCustomerThirdPartyJsonList(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		List<EgovMap> thirdpartylist = null;
		//params
		params.put("custId", params.get("custId"));
		logger.info("##### customer Third Party Parsing START #####");
		thirdpartylist = customerService.selectCustomerThirdPartyJsonList(params);
		
		return ResponseEntity.ok(thirdpartylist);
	}
	
	
	/**
	 * 
	 * Customer Address Detail View 주소 리스트의 해당 상세화면
	 * @param params
	 * @param model
	 * @return
	 * @author 이석희 2017.07.20
	 * */
	@RequestMapping(value = "/selectCustomerAddrDetailView.do")
	public String selectCustomerDetailAddr(@RequestParam Map<String, Object> params, ModelMap model)throws Exception{
		
		EgovMap detailaddr = null;
		//TODO 추후삭제 
		params.put("custAddId", params.get("getparam"));
		logger.info("##### selectCustomerDetailAddr START #####");
		detailaddr = customerService.selectCustomerDetailAddr(params);
		model.addAttribute("detailaddr", detailaddr);
		
		return "sales/customer/customerAddress";
	}
	
	
	/**
	 * 
	 * Customer Bank Detail View 은행 리스트의 해당 상세화면
	 * @param params
	 * @param model
	 * @return
	 * @author 이석희 2017.07.20
	 * */
	@RequestMapping(value = "/selectCustomerBankDetailView.do")
	public String selectCustomerDetailBank(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		EgovMap detailbank = null;
		params.put("custAccId", params.get("getparam"));
		logger.info("##### selectCustomerDetailBank START #####");
		detailbank = customerService.selectCustomerDetailBank(params);
		model.addAttribute("detailbank", detailbank);
		
		return "sales/customer/customerBank";
	}
	
	
	/**
	 * 
	 * Customer Bank Detail View 은행 리스트의 해당 상세화면
	 * @param params
	 * @param model
	 * @return
	 * @author 이석희 2017.07.20
	 * */
	@RequestMapping(value = "/selectCustomerCreditCardDetailView.do")
	public String selectCustomerDetailCreditCard(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		EgovMap detailcard = null;
		//param
		params.put("custCrcId", params.get("getparam"));
		logger.info("##### selectCustomerDetail Credit Card START #####");
		detailcard = customerService.selectCustomerDetailCreditCard(params);
		
		model.addAttribute("detailcard", detailcard);
		
		return "sales/customer/customerCard";
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
		
		//param
		params.put("custId", params.get("custId"));
		params.put("custAddrId", params.get("custAddrId"));
		
		logger.info("##### customeView START #####");
		basicinfo = customerService.selectCustomerViewBasicInfo(params);
		addresinfo = customerService.selectCustomerViewMainAddress(params);
		contactinfo = customerService.selectCustomerViewMainContact(params);
		
		//ajax param
		model.addAttribute("custId", params.get("custId"));
		model.addAttribute("custAddrId", params.get("custAddrId"));
		// infomation param
		model.addAttribute("result", basicinfo);
		model.addAttribute("addresinfo", addresinfo);
		model.addAttribute("contactinfo", contactinfo);
	
		return "sales/customer/customerView";
	}
	
	
	/**
	 * 
	 * Customer Contact Detail View 연락처 리스트의 해당 상세화면
	 * @param params
	 * @param model
	 * @return
	 * @author 이석희 2017.07.25
	 * */
	@RequestMapping(value = "/selectCustomerContactDetailView.do")
	public String selectCustomerContactAddr(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model)throws Exception{
		
		EgovMap detailcontact = null;
		
		params.put("custCntcId", params.get("getparam"));
		logger.info("##### selectCustomerDetailContact START #####");
		detailcontact = customerService.selectCustomerDetailContact(params);
		logger.info("확인 : " + detailcontact.toString());
		model.addAttribute("detailcontact", detailcontact);
		
		return "sales/customer/customerContact";
	}
	
	
}
