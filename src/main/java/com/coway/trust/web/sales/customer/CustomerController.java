package com.coway.trust.web.sales.customer;

import java.sql.Clob;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.customer.CustomerService;
import com.coway.trust.biz.sales.customer.CustomerVO;
import com.coway.trust.cmmn.model.ReturnMessage;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/customer")
public class CustomerController {
	
	private static final Logger logger = LoggerFactory.getLogger(CustomerController.class);
	
	@Resource(name = "customerService")
	private CustomerService customerService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

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
	 * New Customer Registration 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/customerRegistPop.do")
	public String insertPop(ModelMap model){
		logger.info("##### customerRegist START #####");
		return "sales/customer/customerRegistPop";
	}
	
	
	/**
	 * New Customer Add Credit Card Pop 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/customerAddCreditCardPop.do")
	public String customerAddCreditCardPop(ModelMap model){
		logger.info("##### customerRegist START #####");
		return "sales/customer/customerCreditCardPop";
	}
	
	
	/**
	 * New Customer Add Bank Account Pop 
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/customerAddBankAccountPop.do")
	public String customerAddBankAccountPop(ModelMap model){
		logger.info("##### customerRegist START #####");
		return "sales/customer/customerBankAccountPop"	;
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
		logger.info("44444444444444444444 test param 4444444444 : {}" , params.get("custID"));
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
	@RequestMapping(value = "/selectCustomerAddrDetailViewPop.do")
	public String selectCustomerAddrDetailViewPop(@RequestParam Map<String, Object> params, ModelMap model)throws Exception{
		
		EgovMap detailaddr = null;
		logger.info("##### selectCustomerDetailAddr START #####");
		detailaddr = customerService.selectCustomerAddrDetailViewPop(params);
		model.addAttribute("detailaddr", detailaddr);
		
		return "sales/customer/customerAddressPop";
	}
	
	
	/**
	 * 
	 * Customer Contact Detail View 연락처 리스트의 해당 상세화면
	 * @param params
	 * @param model
	 * @return
	 * @author 이석희 2017.07.25
	 * */
	@RequestMapping(value = "/selectCustomerContactDetailViewPop.do")
	public String selectCustomerContactDetailViewPop(@RequestParam Map<String, Object> params,HttpServletRequest request, ModelMap model)throws Exception{
		
		EgovMap detailcontact = null;
		
		logger.info("##### selectCustomerDetailContact START #####");
		detailcontact = customerService.selectCustomerContactDetailViewPop(params);
		logger.info("확인 : " + detailcontact.toString());
		model.addAttribute("detailcontact", detailcontact);
		
		return "sales/customer/customerContactPop";
	}
	
	
	/**
	 * 
	 * Customer Bank Detail View 은행 리스트의 해당 상세화면
	 * @param params
	 * @param model
	 * @return
	 * @author 이석희 2017.07.20
	 * */
	@RequestMapping(value = "/selectCustomerBankDetailViewPop.do")
	public String selectCustomerBankDetailViewPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		EgovMap detailbank = null;
		logger.info("##### selectCustomerDetailBank START #####");
		detailbank = customerService.selectCustomerBankDetailViewPop(params);
		model.addAttribute("detailbank", detailbank);
		
		return "sales/customer/customerBankPop";
	}
	
	
	/**
	 * 
	 * Customer Bank Detail View 은행 리스트의 해당 상세화면
	 * @param params
	 * @param model
	 * @return
	 * @author 이석희 2017.07.20
	 * */
	@RequestMapping(value = "/selectCustomerCreditCardDetailViewPop.do")
	public String selectCustomerCreditCardDetailViewPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
		
		EgovMap detailcard = null;
		logger.info("##### selectCustomerDetail Credit Card START #####");
		detailcard = customerService.selectCustomerCreditCardDetailViewPop(params);
		
		model.addAttribute("detailcard", detailcard);
		
		return "sales/customer/customerCardPop";
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
	
		return "sales/customer/customerViewPop";
	}

	
	/**
	 * 
	 * Basic Customer Info 등록
	 * @param params
	 * @param model.
	 * @return
	 * @author 
	 * */
	@RequestMapping(value = "/insCustBasicInfo.do", method = RequestMethod.GET)
	public ResponseEntity<ReturnMessage> insCustBasicInfo(@RequestParam Map<String, Object> params, Model model) {
		
		int getCustId = 0;
		int getCustAddrId = 0;
		int getCustCntcId = 0;
		int getCustCareCntId = 0;
		String defaultDate = "1900-01-01";
		
		getCustId = customerService.getCustIdSeq();
		getCustAddrId = customerService.getCustAddrIdSeq();
		getCustCntcId = customerService.getCustCntcIdSeq();
		getCustCareCntId = customerService.getCustCareCntIdSeq();
		
//		String getCustVano = "98 9920 " + String.Format("{0:0000 0000}", "50158");

		logger.info("##########getCustId ::::::::::::::::   " + getCustId);
		logger.info("##########getCustAddrId :::::::::::   " + getCustAddrId);
		logger.info("##########getCustCntcId :::::::::::   " + getCustCntcId);
		logger.info("##########getCustCareCntId :::::::   " + getCustCareCntId);
		logger.info("##########cmbCorpTypeId :String::   " + (String)params.get("gstRgistNo"));
		logger.info("##########cmbCorpTypeId :::::::::   " + params.get("gstRgistNo"));
		
		Map<String, Object> insmap = new HashMap();	
		// Basic Info
		insmap.put("getCustId", getCustId);
		insmap.put("custName", (String)params.get("custName"));
		insmap.put("cmbNation", params.get("cmbNation") != null ? (int)params.get("cmbNation") : 0);
		insmap.put("dob", (String)params.get("dob") != null ? (String)params.get("dob") : defaultDate);
		insmap.put("nric", (String)params.get("nric") != null ? (String)params.get("nric") : "");
		insmap.put("gender", (String)params.get("gender") != null ? (String)params.get("gender") : "");
		insmap.put("cmbRace", params.get("cmbRace") != null ? params.get("cmbRace") : 0);
		insmap.put("email", (String)params.get("email") != null ? (String)params.get("email") : "");
//		if(params.get("rem") != null){
//			insmap.put("rem",params.get("rem"));
//		}else{
			insmap.put("rem", null);
//		}
		
//		insmap.put("rem", params.get("rem") != null ? params.get("rem") : "");
		insmap.put("stusCodeId", 1);
		insmap.put("updUserId", 999999);		// 임시번호 (login User로 바꿔야)
		insmap.put("renGrp", "");
		insmap.put("pstTerms", 0);
		insmap.put("idOld", 0);
		insmap.put("crtUserId", 999999);			// 임시번호 (login User로 바꿔야)
		insmap.put("cmbTypeId",params.get("cmbTypeId"));
		insmap.put("pasSportExpr", (String)params.get("pasSportExpr") != null ? (String)params.get("pasSportExpr") : defaultDate);
		insmap.put("visaExpr", (String)params.get("visaExpr") != null ? (String)params.get("visaExpr") : defaultDate);
		insmap.put("cmbCorpTypeId", (int)params.get("cmbTypeId") == 965 ? params.get("cmbCorpTypeId") : 0);
		insmap.put("gstRgistNo", (String)params.get("gstRgistNo") != null ? (String)params.get("gstRgistNo") : "");
		
		// Address
		insmap.put("getCustAddrId", getCustAddrId);
		insmap.put("addr1", (String)params.get("addr1"));
		insmap.put("addr2", (String)params.get("addr2"));
		insmap.put("addr3", (String)params.get("addr3"));
		insmap.put("addr4", "");
		insmap.put("postCodeId", params.get("cmbPostCd") != null ? params.get("cmbPostCd") : 0);
		insmap.put("postCode", "");
		insmap.put("areaId", params.get("cmbArea") != null ? params.get("cmbArea") : 0);
		insmap.put("area", "");
		insmap.put("stateId", params.get("mstate") != null ? params.get("mstate") : 0);
		insmap.put("cntyId", 1);
		insmap.put("stusCodeId", 9);
		insmap.put("addrRem", params.get("addrRem"));
		insmap.put("idOld", 0);
		insmap.put("soId", 0);
		insmap.put("idcm", 0);
		
		// additional service contact
		insmap.put("getCustCntcId", getCustCntcId);
		insmap.put("getCustCareCntId", getCustCareCntId);
		insmap.put("custInitial", params.get("custInitial") != null ? params.get("custInitial") : 0);
		insmap.put("pos", "");
		insmap.put("telM1", (String)params.get("telM1"));
		insmap.put("telM2", "");
		insmap.put("telO", (String)params.get("telO"));
		insmap.put("telR", (String)params.get("telR"));
		insmap.put("telF", (String)params.get("telF"));
		insmap.put("dept", "");
		insmap.put("dcm", 0);
		insmap.put("ext", (String)params.get("ext"));
		
		insmap.put("asTelM", (String)params.get("asTelM"));
		insmap.put("asTelO", (String)params.get("asTelO"));
		insmap.put("asTelR", (String)params.get("asTelR"));
		insmap.put("asTelF", (String)params.get("asTelF"));
		insmap.put("asExt", (String)params.get("asExt"));
		insmap.put("asEmail", (String)params.get("asEmail"));
		insmap.put("asCustName", (String)params.get("asCustName"));
		
		
		customerService.insertCustomerInfo(insmap);
		customerService.insertAddressInfo(insmap);
		customerService.insertContactInfo(insmap);
		customerService.insertCareContactInfo(insmap);
		
		
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		
		return ResponseEntity.ok(message);
	}
}
