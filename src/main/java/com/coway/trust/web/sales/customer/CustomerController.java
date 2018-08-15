package com.coway.trust.web.sales.customer;

import java.text.ParseException;
import java.util.ArrayList;
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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.customer.CustomerBVO;
import com.coway.trust.biz.sales.customer.CustomerCVO;
import com.coway.trust.biz.sales.customer.CustomerService;
import com.coway.trust.biz.sales.customer.CustomerVO;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/sales/customer")
public class CustomerController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CustomerController.class);

	@Resource(name = "customerService")
	private CustomerService customerService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@RequestMapping(value = "/selectIssueBank.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectIssueBank(@RequestParam Map<String, Object> params, Model model) {
		List<EgovMap> bankList = customerService.selectIssueBank(params);
		LOGGER.debug("bankList :::::   " + bankList.toString());
		return ResponseEntity.ok(bankList);
	}

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

		LOGGER.info("##### customerList START #####");
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
	public String insertPop(@RequestParam Map<String, Object> params, ModelMap model){
		LOGGER.info("##### customerRegist START #####");
		model.put("callPrgm", params.get("callPrgm"));

			return "sales/customer/customerRegistPop";
	}

	/**
	 * New Customer Registration
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/customerRegistPopESales.do")
	public String insertPopESales(@RequestParam Map<String, Object> params, ModelMap model){

		LOGGER.debug("params ======================================>>> " + params);
		LOGGER.info("##### customerRegist START #####");
		model.put("callPrgm", params.get("callPrgm"));
		model.put("nric", params.get("nric"));

			return "sales/customer/customerRegistPopESales";
	}

	/**
	 * New Customer Add Credit Card Pop
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/customerAddCreditCardPop.do")
	public String customerAddCreditCardPop(@RequestParam Map<String, Object> params, ModelMap model){
		LOGGER.info("##### customerRegist START #####");

		List<EgovMap> bankList = customerService.selectIssueBank(params);
		model.addAttribute("bankList", bankList);

		return "sales/customer/customerCreditCardPop";
	}

	/**
	 * New Customer Add Credit Card Pop
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/customerAddCreditCardeSalesPop.do")
	public String customerAddCreditCardeSalesPop(@RequestParam Map<String, Object> params, ModelMap model){
		LOGGER.info("##### customerRegist START #####");

		List<EgovMap> bankList = customerService.selectIssueBank(params);
		model.addAttribute("bankList", bankList);

		return "sales/customer/customerCreditCardeSalesPop";
	}

	/**
	 * New Customer Add Bank Account Pop
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/customerAddBankAccountPop.do")
	public String customerAddBankAccountPop(@RequestParam Map<String, Object> params, ModelMap model){

		List<EgovMap> accBankList = customerService.selectAccBank(params);
		model.addAttribute("accBankList", accBankList);



		return "sales/customer/customerBankAccountPop"	;
	}

	/**
	 * New Customer Add Bank Account Pop
	 * @param params
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/customerBankAccountAddPop.do")
	public String customerBankAccountAddPop(@RequestParam Map<String, Object> params, ModelMap model){

		model.put("custId", params.get("custId"));
		model.put("callPrgm", params.get("callPrgm"));

		return "sales/customer/customerBankAccountAddPop"	;
	}

	@RequestMapping(value = "/customerCreditCardAddPop.do")
	public String customerCreditCardAddPop(@RequestParam Map<String, Object> params, ModelMap model){

		model.put("custId", params.get("custId"));
		model.put("callPrgm", params.get("callPrgm"));

		return "sales/customer/customerCreditCardAddPop"	;
	}

	@RequestMapping(value = "/customerCreditCardeSalesAddPop.do")
	public String customerCreditCardeSalesAddPop(@RequestParam Map<String, Object> params, ModelMap model){

		model.put("custId", params.get("custId"));
		model.put("callPrgm", params.get("callPrgm"));

		return "sales/customer/customerCreditCardeSalesAddPop"	;
	}

	@RequestMapping(value = "/insertBankAccountInfo2.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertBankAccountInfo2(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws ParseException {

		int custAccId = customerService.insertBankAccountInfo2(params, sessionVO);

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
//		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setMessage("New bank account added.");
		message.setData(custAccId);

		return ResponseEntity.ok(message);
	}

	@RequestMapping(value = "/insertCreditCardInfo2.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> insertCreditCardInfo2(@RequestBody Map<String, Object> params, ModelMap model, SessionVO sessionVO) throws ParseException {

		int custCrcId = customerService.insertCreditCardInfo2(params, sessionVO);;

		// 결과 만들기
		ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
//		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setMessage("New credit card added.");
		message.setData(custCrcId);

		return ResponseEntity.ok(message);
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
		LOGGER.info("##### customer Address Parsing START #####");
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
		LOGGER.info("##### customer Contact Parsing START #####");
		contactlist = customerService.selectCustomerContactJsonList(params);
		// 데이터 리턴.
		return ResponseEntity.ok(contactlist);
	}

	@RequestMapping(value = "/customerConctactSearchPop.do")
	public String customerPop(@RequestParam Map<String, Object> params, ModelMap model) {

		model.put("callPrgm", params.get("callPrgm"));
		model.put("custId", params.get("custId"));

		return "sales/customer/customerContactSearchPop";
	}

	/**
	 * Customer 상세 조회 Contact List
	 * @param params
	 * @param model
	 * @return ResponseEntity
	 */
	@RequestMapping(value = "/selectCustCareContactList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectCustCareContactList(@RequestParam Map<String, Object>params, ModelMap model)throws Exception{
		List<EgovMap> contactlist = customerService.selectCustCareContactList(params);
		return ResponseEntity.ok(contactlist);
	}

	/**
	 * Billing Group 상세 조회 Contact List
	 * @param params
	 * @param model
	 * @return ResponseEntity
	 */
	@RequestMapping(value = "/selectBillingGroupByKeywordCustIDList.do", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> selectBillingGroupByKeywordCustIDList(@RequestParam Map<String, Object>params, ModelMap model)throws Exception{
		List<EgovMap> grpList = customerService.selectBillingGroupByKeywordCustIDList(params);
		return ResponseEntity.ok(grpList);
	}

	@RequestMapping(value = "/customerAddressSearchPop.do")
	public String customerAddressSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {

		model.put("callPrgm", params.get("callPrgm"));
		model.put("custId", params.get("custId"));

		return "sales/customer/customerAddressSearchPop";
	}

	@RequestMapping(value = "/customerBankAccountSearchPop.do")
	public String customerBankAccountSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {

		model.put("callPrgm", params.get("callPrgm"));
		model.put("custId", params.get("custId"));

		return "sales/customer/customerBankAccountSearchPop";
	}

	@RequestMapping(value = "/customerBillGrpSearchPop.do")
	public String customerBillGrpSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {

		model.put("callPrgm", params.get("callPrgm"));
		model.put("custId", params.get("custId"));
		LOGGER.info("callPrgm @@@@@@@@@@@@@@@@ :: " + params.get("callPrgm"));
		return "sales/customer/customerBillGrpSearchPop";
	}

	@RequestMapping(value = "/customerCreditCardSearchPop.do")
	public String customerCreditCardSearchPop(@RequestParam Map<String, Object> params, ModelMap model) {

		model.put("callPrgm", params.get("callPrgm"));
		model.put("custId", params.get("custId"));

		return "sales/customer/customerCreditCardSearchPop";
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
		LOGGER.info("##### customer Bank List Parsing START #####");
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
		LOGGER.info("##### customer Card List Parsing START #####");
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
		LOGGER.info("##### customer Own Order Parsing START #####");
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
		LOGGER.info("##### customer Third Party Parsing START #####");
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
		LOGGER.info("##### selectCustomerDetailAddr START #####");
		detailaddr = customerService.selectCustomerAddrDetailViewPop(params);
		LOGGER.info("##### detailaddr : " + detailaddr.toString());
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

		LOGGER.info("##### selectCustomerDetailContact START #####");
		detailcontact = customerService.selectCustomerContactDetailViewPop(params);
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
		LOGGER.info("##### selectCustomerDetailBank START #####");
		detailbank = customerService.selectCustomerBankDetailViewPop(params);
		model.addAttribute("detailbank", detailbank);

		return "sales/customer/customerBankPop";
	}


	/**
	 *
	 * Customer Card Detail View Card 리스트의 해당 상세화면
	 * @param params
	 * @param model
	 * @return
	 * @author 이석희 2017.07.20
	 * */
	@RequestMapping(value = "/selectCustomerCreditCardDetailViewPop.do")
	public String selectCustomerCreditCardDetailViewPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

		EgovMap detailcard = null;
		LOGGER.info("##### selectCustomerDetail Credit Card START #####");
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

		LOGGER.info("##### customeView START #####");
		basicinfo = customerService.selectCustomerViewBasicInfo(params);
		addresinfo = customerService.selectCustomerViewMainAddress(params);
		contactinfo = customerService.selectCustomerViewMainContact(params);

		//ajax param
		model.addAttribute("custId", params.get("custId"));
		model.addAttribute("custAddrId", params.get("custAddrId"));
		model.addAttribute("custCntcId" , params.get("custCntcId"));
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
	@RequestMapping(value = "/insCustBasicInfo.do", method = RequestMethod.POST)
	public ResponseEntity<Integer> insCustBasicInfo(@RequestBody CustomerForm customerForm, Model model) throws Exception{

		int getCustCareCntId = 0;
		String defaultDate = "01/01/1900";
		SessionVO sessionVo = sessionHandler.getCurrentSessionInfo();
		CustomerVO vo = customerForm.getCustomerVO();

		// Credit Card addList
		GridDataSet<CustomerCardListGridForm> dataSet = customerForm.getDataSet();
		List<CustomerCardListGridForm> addList = dataSet.getAdd();
		List<CustomerCVO> customerCardVOList = new ArrayList<>();
		// Bank Account addList
		GridDataSet<CustomerBankAccListGridForm> dataSetBank = customerForm.getDataSetBank();
		List<CustomerBankAccListGridForm> addBankList = dataSetBank.getAdd();
		List<CustomerBVO> customerBankVOList = new ArrayList<>();

		getCustCareCntId = customerService.getCustCareCntIdSeq();

		LOGGER.info("##########getCustCareCntId :::::::   " + getCustCareCntId);

		Map<String, Object> insmap = new HashMap();

		Map<String, Object> ins29Dmap = new HashMap();

		// Basic Info
		int tempCustSeq = 0 ;
		tempCustSeq = customerService.getCustIdSeq();

		insmap.put("custSeq", tempCustSeq);
		insmap.put("custName", vo.getCustName());
		insmap.put("cmbNation", String.valueOf(vo.getCmbNation()) != null ? vo.getCmbNation() : 0);
		if(vo.getDob() != null && !"".equals(vo.getDob())){
			insmap.put("dob", vo.getDob());
		}else{
			insmap.put("dob", defaultDate);
		}
		insmap.put("nric", vo.getNric() != null ? vo.getNric() : "");
		insmap.put("oldNric", vo.getOldNric() != null ? vo.getOldNric() : "");
		LOGGER.info("##########vo.getGender() :::::::   " + vo.getGender());
		insmap.put("gender", vo.getGender() != null ? vo.getGender() : "");
		insmap.put("cmbRace", String.valueOf(vo.getCmbRace()) != null ? vo.getCmbRace() : 0);
		insmap.put("email", vo.getEmail() != null ? vo.getEmail() : "");
		if(vo.getRem() != null){
			insmap.put("rem",vo.getRem());
		}else{
			insmap.put("rem", null);
		}
		insmap.put("stusCodeId", 1);				//고정
		insmap.put("updUserId", sessionVo.getUserId());
		insmap.put("renGrp", "");					//고정
		insmap.put("pstTerms", 0);					//고정
		insmap.put("idOld", 0);						//고정
		insmap.put("crtUserId", sessionVo.getUserId());
		insmap.put("cmbTypeId", vo.getCmbTypeId());
		insmap.put("pasSportExpr", vo.getPasSportExpr() != null ? vo.getPasSportExpr() : defaultDate);
		insmap.put("visaExpr", vo.getVisaExpr() != null ? vo.getVisaExpr() : defaultDate);
		insmap.put("cmbCorpTypeId", vo.getCmbTypeId() == 965 ? vo.getCmbCorpTypeId() : 0);
		insmap.put("gstRgistNo", vo.getGstRgistNo() != null ? vo.getGstRgistNo() : "");

//		98 9920 0068 7067

		String getCustVano = "";
		int custseqLenghth = Integer.toString(tempCustSeq).length();
		String tempCustSeqVa = String.valueOf(tempCustSeq);
		LOGGER.info("##########custseqLenghth :::::::   " + custseqLenghth);
		LOGGER.info("##########tempCustSeqVa :::::::   " + tempCustSeqVa);
		if(custseqLenghth == 4){
			getCustVano = "98 9920 0000" + tempCustSeqVa;
		}else if(custseqLenghth == 5){
			getCustVano = "98 9920 000" + tempCustSeqVa.substring(0,1) + " " + tempCustSeqVa.substring(1);
		}else if(custseqLenghth == 6){
			getCustVano = "98 9920 00" + tempCustSeqVa.substring(0,2) + " " + tempCustSeqVa.substring(2);
		}else if(custseqLenghth == 7){
			getCustVano = "98 9920 0" + tempCustSeqVa.substring(0,3) + " " + tempCustSeqVa.substring(3);
		}else if(custseqLenghth == 8){
			getCustVano = "98 9920 " + tempCustSeqVa.substring(0,4) + " " + tempCustSeqVa.substring(4);
		}


		ins29Dmap.put("getCustVano", getCustVano);
		ins29Dmap.put("custSeq", tempCustSeq);
		ins29Dmap.put("custName", vo.getCustName());
		ins29Dmap.put("cmbNation", String.valueOf(vo.getCmbNation()) != null ? vo.getCmbNation() : 0);
		if(vo.getDob() != null && !"".equals(vo.getDob())){
			ins29Dmap.put("dob", vo.getDob());
		}else{
			ins29Dmap.put("dob", defaultDate);
		}
		ins29Dmap.put("nric", vo.getNric() != null ? vo.getNric() : "");
		ins29Dmap.put("oldNric", vo.getOldNric() != null ? vo.getOldNric() : "");
		LOGGER.info("########## vo.getGender() :::::::   " + vo.getGender());
		ins29Dmap.put("gender", vo.getGender() != null ? vo.getGender() : "");
		ins29Dmap.put("cmbRace", String.valueOf(vo.getCmbRace()) != null ? vo.getCmbRace() : 0);
		ins29Dmap.put("email", vo.getEmail() != null ? vo.getEmail() : "");
		if(vo.getRem() != null){
			ins29Dmap.put("rem",vo.getRem());
		}else{
			ins29Dmap.put("rem", null);
		}
		ins29Dmap.put("stusCodeId", 1);				//고정
		ins29Dmap.put("updUserId", sessionVo.getUserId());
		ins29Dmap.put("renGrp", "");					//고정
		ins29Dmap.put("pstTerms", 0);					//고정
		ins29Dmap.put("idOld", 0);						//고정
		ins29Dmap.put("crtUserId", sessionVo.getUserId());
		ins29Dmap.put("cmbTypeId", vo.getCmbTypeId());
		ins29Dmap.put("pasSportExpr", vo.getPasSportExpr() != null ? vo.getPasSportExpr() : defaultDate);
		ins29Dmap.put("visaExpr", vo.getVisaExpr() != null ? vo.getVisaExpr() : defaultDate);
		ins29Dmap.put("cmbCorpTypeId", vo.getCmbTypeId() == 965 ? vo.getCmbCorpTypeId() : 0);
		ins29Dmap.put("gstRgistNo", vo.getGstRgistNo() != null ? vo.getGstRgistNo() : "");

		// Address
		insmap.put("addrDtl", vo.getAddrDtl());
		insmap.put("areaId", vo.getAreaId());
		insmap.put("streetDtl", vo.getStreetDtl());


//		insmap.put("addr3", vo.getAddr3());
//		insmap.put("addr4", "");										//고정
//		insmap.put("postCodeId", String.valueOf(vo.getCmbPostCd()) != null ? vo.getCmbPostCd() : 0);
//		insmap.put("postCode", "");								//고정
//		insmap.put("areaId", String.valueOf(vo.getCmbArea()) != null ? vo.getCmbArea() : 0);
//		insmap.put("area", "");										//고정
//		insmap.put("stateId", String.valueOf(vo.getMstate()) != null ? vo.getMstate() : 0);
//		insmap.put("cntyId", 1);									//고정 (cmbCoountry)
		insmap.put("stusCodeId", 9);								//고정
		insmap.put("addrRem", vo.getAddrRem());				//고정
		insmap.put("idOld", 0);										//고정
		insmap.put("soId", 0);										//고정
		insmap.put("idcm", 0);										//고정

		// additional service contact
		insmap.put("getCustCareCntId", getCustCareCntId);
		insmap.put("custInitial", String.valueOf(vo.getCustInitial()) != null ? vo.getCustInitial() : 0);
		insmap.put("pos", "");										//고정
		insmap.put("telM1", vo.getTelM1());
		insmap.put("telM2", "");										//고정
		insmap.put("telO", vo.getTelO());
		insmap.put("telR", vo.getTelR());
		insmap.put("telF", vo.getTelF());
		insmap.put("dept", "");										//고정
		insmap.put("dcm", 0);										//고정
		insmap.put("ext", vo.getExt());

		insmap.put("asTelM", vo.getAsTelM());
		insmap.put("asTelO", vo.getAsTelO());
		insmap.put("asTelR", vo.getAsTelR());
		insmap.put("asTelF", vo.getAsTelF());
		insmap.put("asExt", vo.getAsExt());
		insmap.put("asEmail", vo.getAsEmail());
		insmap.put("asCustName", vo.getAsCustName());

		/* NRIC Dup Check*/

		EgovMap nricDupMap = customerService.nricDupChk(insmap);
		if(nricDupMap != null){
			return null;
		}

		LOGGER.info("########## ins29Dmap :::::::   " + ins29Dmap.toString());

		customerService.insertCustomerInfo(ins29Dmap);
		customerService.insertAddressInfo(insmap);
		customerService.insertContactInfo(insmap);
		customerService.insertCareContactInfo(insmap);

		// insert Credit Card Info
		if(addList != null){
		//	int getCustCrcIdSeq = customerService.getCustCrcIdSeq();
			addList.forEach(form -> {
				CustomerCVO customerCVO = new CustomerCVO();
				customerCVO.setCrcType(form.getCrcType());
				customerCVO.setBank(form.getBank());
				customerCVO.setCardType(form.getCardType());
				customerCVO.setCardRem(null);					//임시
			//	customerCVO.setGetCustCrcIdSeq(getCustCrcIdSeq);
				customerCVO.setCrcNo(null);						//암호화 코드
				customerCVO.setCreditCardNo(form.getCreditCardNo());
				customerCVO.setEncCrcNo(null);				//암호화 코드
				customerCVO.setNmCard(form.getNmCard());
				customerCVO.setCrcStusId(1);					//고정
				customerCVO.setCrcUpdId(999999);			//임시
				customerCVO.setCrcCrtId(999999);				//임시

				String cardExpiry = form.getCardExpiry();
				if(cardExpiry != null){
					cardExpiry = cardExpiry.substring(0,2) +cardExpiry.substring(5,7);
				}else{
					cardExpiry = null;
				}
				customerCVO.setCardExpiry(cardExpiry);
				customerCVO.setCrcIdOld(0);						//고정
				customerCVO.setSoId(0);							//고정
				customerCVO.setCrcIdcm(0);						//고정

				customerCardVOList.add(customerCVO);


			});

			customerService.insertCreditCardInfo(customerCardVOList);
			LOGGER.info("추가 : {}", addList.toString());
		}

		// insert Bank Account Info
		if(addBankList != null){
		//	int getCustAccIdSeq = customerService.getCustAccIdSeq();
			addBankList.forEach(form -> {
				CustomerBVO customerBVO = new CustomerBVO();
			//	customerBVO.setGetCustAccIdSeq(getCustAccIdSeq);
				customerBVO.setAccNo(form.getAccNo());
				customerBVO.setEncAccNo(form.getEncAccNo());
				customerBVO.setAccOwner(form.getAccOwner());
				customerBVO.setAccTypeId(form.getAccTypeId()); //0
				customerBVO.setAccBankId(form.getAccBankId()); //0
				customerBVO.setAccBankBrnch(form.getAccBankBrnch());
				customerBVO.setAccRem(form.getAccRem());
				customerBVO.setAccStusId(1);
				customerBVO.setAccUpdUserId(999999); 			//임시
				customerBVO.setAccNric("");							//고정
				customerBVO.setAccIdOld(0);							//고정
				customerBVO.setSoId(0);								//고정
				customerBVO.setAccIdcm(0);							//고정
				customerBVO.setHlbbId(0);							//고정
				customerBVO.setAccCrtUserId(999999);			//임시

				customerBankVOList.add(customerBVO);
			});

			customerService.insertBankAccountInfo(customerBankVOList);
			LOGGER.info("Bank추가 : {}", addBankList.toString());
		}


		/*ReturnMessage message = new ReturnMessage();
		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));*/


		return ResponseEntity.ok(tempCustSeq);
	}

	/**
	 *
	 * NRIC / Company No 중복체크
	 * @param params
	 * @param model.
	 * @return
	 * @author
	 * */
	@RequestMapping(value = "/nricDupChk.do", method = RequestMethod.POST)
	public ResponseEntity<EgovMap> nricDupChk(@RequestBody Map<String, Object> params, ModelMap model) throws Exception{
		LOGGER.debug("NRIC  :::::::::::::::::::::::::::::::::::::::::::::: {}", params.get("nric"));
		EgovMap dupMap = null;

		dupMap = customerService.nricDupChk(params);

		return ResponseEntity.ok(dupMap);
	}


	// Customer Edit Controller
		/**
		 *
		 * Customer Basic Info Edit 기본 정보 수정
		 * @param params
		 * @param model
		 * @return
		 * @author 이석희 2017.07.27
		 * */
		@RequestMapping(value = "/updateCustomerBasicInfoPop.do")
		public String updateCustomerBasicInfoPop(@RequestParam Map<String, Object> params, ModelMap model)throws Exception{

			EgovMap basicinfo = null;
			EgovMap addresinfo = null;
			EgovMap contactinfo = null;
			// custId custAddId custCntcId

			basicinfo = customerService.selectCustomerViewBasicInfo(params);
			addresinfo = customerService.selectCustomerViewMainAddress(params);
			contactinfo = customerService.selectCustomerViewMainContact(params);
			//page param
			model.addAttribute("custId", params.get("custId"));
			model.addAttribute("custAddId", params.get("custAddId"));
			model.addAttribute("custCntcId", params.get("custCntcId"));
			model.addAttribute("selectParam", params.get("selectParam"));
			// infomation param
			model.addAttribute("result", basicinfo);
			model.addAttribute("addresinfo", addresinfo);
			model.addAttribute("contactinfo", contactinfo);

			return "sales/customer/customerBasicEditPop";
		}


		/**
		 *
		 * Customer Address Edit 기본 정보 수정
		 * @param params
		 * @param model
		 * @return
		 * @author 이석희 2017.07.28
		 * */
		@RequestMapping(value = "/updateCustomerAddressPop.do")
		public String updateCustomerAddressPop(@RequestParam Map<String, Object> params, ModelMap model)throws Exception{

			EgovMap basicinfo = null;
			EgovMap addresinfo = null;
			EgovMap contactinfo = null;

			LOGGER.info("##### customer Address Edit START #####");
			LOGGER.info("##### selParam :  ##### = " + params.get("selectParam"));
			basicinfo = customerService.selectCustomerViewBasicInfo(params);
			addresinfo = customerService.selectCustomerViewMainAddress(params);
			contactinfo = customerService.selectCustomerViewMainContact(params);

			//page param
			model.addAttribute("custId", params.get("custId"));
			model.addAttribute("custAddId", params.get("custAddId"));
			model.addAttribute("custCntcId", params.get("custCntcId"));
			model.addAttribute("selectParam", params.get("selectParam"));
			// infomation param
			model.addAttribute("result", basicinfo);
			model.addAttribute("addresinfo", addresinfo);
			model.addAttribute("contactinfo", contactinfo);

			return "sales/customer/customerAddressEditPop";
		}


		/**
		 *
		 * Customer Contact Edit 기본 정보 수정
		 * @param params
		 * @param model
		 * @return
		 * @author 이석희 2017.07.28
		 * */
		@RequestMapping(value = "/updateCustomerContactPop.do")
		public String updateCustomerContactPop(@RequestParam Map<String, Object> params, ModelMap model)throws Exception{

			EgovMap basicinfo = null;
			EgovMap addresinfo = null;
			EgovMap contactinfo = null;

			LOGGER.info("##### customer Contact Edit START #####");
			basicinfo = customerService.selectCustomerViewBasicInfo(params);
			addresinfo = customerService.selectCustomerViewMainAddress(params);
			contactinfo = customerService.selectCustomerViewMainContact(params);
			//page param
			model.addAttribute("custId", params.get("custId"));
			model.addAttribute("custAddId", params.get("custAddId"));
			model.addAttribute("custCntcId", params.get("custCntcId"));
			model.addAttribute("selectParam", params.get("selectParam"));
			// infomation param
			model.addAttribute("result", basicinfo);
			model.addAttribute("addresinfo", addresinfo);
			model.addAttribute("contactinfo", contactinfo);

			return "sales/customer/customerContactEditPop";
		}


		/**
		 *
		 * Customer Bank Account Edit 기본 정보 수정
		 * @param params
		 * @param model
		 * @return
		 * @author 이석희 2017.07.28
		 * */
		@RequestMapping(value = "/updateCustomerBankAccountPop.do")
		public String updateCustomerBankAccountPop(@RequestParam Map<String, Object> params, ModelMap model)throws Exception{

			EgovMap basicinfo = null;
			EgovMap addresinfo = null;
			EgovMap contactinfo = null;

			LOGGER.info("##### customer Bank Acc Edit START #####");
			basicinfo = customerService.selectCustomerViewBasicInfo(params);
			addresinfo = customerService.selectCustomerViewMainAddress(params);
			contactinfo = customerService.selectCustomerViewMainContact(params);

			//page param
			model.addAttribute("custId", params.get("custId"));
			model.addAttribute("custAddId", params.get("custAddId"));
			model.addAttribute("custCntcId", params.get("custCntcId"));
			model.addAttribute("selectParam", params.get("selectParam"));
			// infomation param
			model.addAttribute("result", basicinfo);
			model.addAttribute("addresinfo", addresinfo);
			model.addAttribute("contactinfo", contactinfo);

			return "sales/customer/customerBankAccEditPop";
		}


		/**
		 *
		 * Customer Credit Card Edit 기본 정보 수정
		 * @param params
		 * @param model
		 * @return
		 * @author 이석희 2017.07.28
		 * */
		@RequestMapping(value = "/updateCustomerCreditCardPop.do")
		public String updateCustomerCreditCardPop(@RequestParam Map<String, Object> params, ModelMap model)throws Exception{

			EgovMap basicinfo = null;
			EgovMap addresinfo = null;
			EgovMap contactinfo = null;

			LOGGER.info("##### customer Credit Card Edit START #####");
			basicinfo = customerService.selectCustomerViewBasicInfo(params);
			addresinfo = customerService.selectCustomerViewMainAddress(params);
			contactinfo = customerService.selectCustomerViewMainContact(params);

			//page param
			model.addAttribute("custId", params.get("custId"));
			model.addAttribute("custAddId", params.get("custAddId"));
			model.addAttribute("custCntcId", params.get("custCntcId"));
			model.addAttribute("selectParam", params.get("selectParam"));
			// infomation param
			model.addAttribute("result", basicinfo);
			model.addAttribute("addresinfo", addresinfo);
			model.addAttribute("contactinfo", contactinfo);

			return "sales/customer/customerCreditCardEditPop";
		}


		/**
		 *
		 * Customer Basic Info (Limitation) Edit 기본 정보 수정
		 * @param params
		 * @param model
		 * @return
		 * @author 이석희 2017.07.28
		 * */

		@RequestMapping(value = "/updateCustomerBasicInfoLimitPop.do")
		public String updateCustomerBasicInfoLimitPop(@RequestParam Map<String, Object> params, ModelMap model)throws Exception{

			EgovMap basicinfo = null;
			EgovMap addresinfo = null;
			EgovMap contactinfo = null;

			LOGGER.info("##### customer Basic Limit Edit START #####");
			basicinfo = customerService.selectCustomerViewBasicInfo(params);

			if(null ==params.get("custAddId") || "" == params.get("custAddId")){
				params.put("custAddId", basicinfo.get("custAddId"));
			}

			if(null ==params.get("custCntcId") || "" == params.get("custCntcId")){
				params.put("custCntcId", basicinfo.get("custCntcId"));
			}

			addresinfo = customerService.selectCustomerViewMainAddress(params);
			contactinfo = customerService.selectCustomerViewMainContact(params);

			//page param
			model.addAttribute("custId", params.get("custId"));
			model.addAttribute("custAddId", params.get("custAddId"));
			model.addAttribute("custCntcId", params.get("custCntcId"));
			model.addAttribute("selectParam", params.get("selectParam"));
			// infomation param
			model.addAttribute("result", basicinfo);
			model.addAttribute("addresinfo", addresinfo);
			model.addAttribute("contactinfo", contactinfo);
			//ComboBox params
			if( null != params.get("useDisable")){
				model.addAttribute("selVisible" , "1");
			}

			return "sales/customer/customerBasicLimitEditPop";
		}


		/**
		 *
		 * Customer Basic Info Edit After 기본 정보 수정 DB Update
		 * @param params
		 * @param model
		 * @return
		 * @author 이석희 2017.08.02
		 * */
		@RequestMapping(value = "/updateCustomerBasicInfoAf.do")
		public ResponseEntity<ReturnMessage> updateCustomerBasicInfoAf(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{
			//Session
			SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
			params.put("userId", sessionVO.getUserId());
			//service
			customerService.updateCustomerBasicInfoAf(params);

			// 결과 만들기 예.
			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

			return ResponseEntity.ok(message);
		}


		/**
		 *
		 * Customer Address Info Edit Set Main 주소 정보 메인 설정
		 * @param params
		 * @param model
		 * @return
		 * @author 이석희 2017.08.02
		 * */
		@RequestMapping(value = "/updateCustomerAddressSetMain.do")
		public ResponseEntity<ReturnMessage> updateCustomerAddressSetMain(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

			LOGGER.info("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ " + params.get("custId"));
			//service
			/*customerService.updateCustomerAddressSetActive(params);*/
			customerService.updateCustomerAddressSetMain(params);
			// set message
			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

			return ResponseEntity.ok(message);
		}


		/**
		 *
		 * Customer Address Info Edit Pop up Window 주소 정보 수정창
		 * @param params
		 * @param model
		 * @return
		 * @author 이석희 2017.08.02
		 * */
		@RequestMapping(value = "/updateCustomerAddressInfoPop.do")
		public String updateCustomerAddressInfoPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

			/*LOGGER.info("팝업창 파라미터 확인 :  custId = " + params.get("custId") + " , custAddId = " + params.get("custAddId"));*/
			EgovMap detailaddr = null;

			LOGGER.info("##### updateCustomerAddressInfoPop START #####");
			LOGGER.info("### 가져온 파라미터 확인 : " + params.get("editCustAddId"));

			params.put("getparam", params.get("editCustAddId"));

			detailaddr = customerService.selectCustomerAddrDetailViewPop(params);
			LOGGER.info("### DetailAddress 정보 확인  : " + detailaddr.toString());
			int billAddrExist = customerService.billAddrExist(params);
			int installAddrExist = customerService.installAddrExist(params);

			LOGGER.info("##### billAddrExist 확인 : " + billAddrExist);
			LOGGER.info("### installAddrExist 확인 : " + installAddrExist);
			model.addAttribute("detailaddr", detailaddr);
			model.addAttribute("billAddrExistCnt", billAddrExist);
			model.addAttribute("installAddrExistCnt", installAddrExist);

			return "sales/customer/customerAddressEditInfoPop";
		}


		/**
		 *
		 * Customer Contact Info Edit Set Main 연락처 정보 메인 설정
		 * @param params
		 * @param model
		 * @return
		 * @author 이석희 2017.08.02
		 * */
		@RequestMapping(value = "updateCustomerContactSetMain.do")
		public ResponseEntity<ReturnMessage> updateCustomerContactSetMain(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{


			//service
			/*customerService.updateCustomerContactSetActive(params);*/
			customerService.updateCustomerContactSetMain(params);
			// set message
			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

			return ResponseEntity.ok(message);
		}


		/**
		 *
		 * Customer Contact Info Edit Pop up Window 주소 정보 수정창
		 * @param params
		 * @param model
		 * @return
		 * @author 이석희 2017.08.03
		 * */
		@RequestMapping(value = "/updateCustomerContactInfoPop.do")
		public String updateCustomerContactInfoPop (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{


			EgovMap detailcontact = null;
			LOGGER.info("##### updateCustomerContactInfoPop START #####");
			params.put("getparam", params.get("editCustCntcId"));
			detailcontact = customerService.selectCustomerContactDetailViewPop(params);
			model.addAttribute("detailcontact", detailcontact);

			return "sales/customer/customerContactEditInfoPop";
		}


		/**
		 *
		 * Customer Contact Info Edit After 연락처 정보 수정 DB Update
		 * @param params
		 * @param model
		 * @return
		 * @author 이석희 2017.08.03
		 * */
		@RequestMapping(value = "/updateCustomerContactInfoAf.do")
		public ResponseEntity<ReturnMessage> updateCustomerContactInfoAf (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

			//service
			customerService.updateCustomerContactInfoAf(params);
			// 결과 만들기 예.
			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

			return ResponseEntity.ok(message);

		}


		/**
		 *
		 * Customer Bank Account Info Edit Pop up Window Bank Account 정보 수정창
		 * @param params
		 * @param model
		 * @return
		 * @author 이석희 2017.08.03
		 * */
		@RequestMapping(value = "/updateCustomerBankAccEditInfoPop.do")
		public String updateCustomerBankAccEditInfoPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

			EgovMap detailbank = null;
			params.put("getparam", params.get("editCustBankId"));
			detailbank = customerService.selectCustomerBankDetailViewPop(params);

			model.addAttribute("detailbank", detailbank);

			return "sales/customer/customerBankAccEditInfoPop";

		}


		/**
		 *
		 * Bank Account ComboBox List
		 * @param params
		 * @param model
		 * @return
		 * @author 이석희 2017.08.04
		 * */
		@RequestMapping(value = "/selectAccBank.do", method = RequestMethod.GET)
		public ResponseEntity<List<EgovMap>> selectAccBank(@RequestParam Map<String, Object> params)throws Exception {

			LOGGER.debug("groupCode : {}", params.get("groupCode"));

			List<EgovMap> codeList = customerService.selectAccBank(params);
			return ResponseEntity.ok(codeList);
		}



		/**
		 *
		 * Credit Card ComboBox List
		 * @param params
		 * @param model
		 * @return
		 * @author 이석희 2017.08.04
		 * */
		@RequestMapping(value = "/selectCrcBank.do", method = RequestMethod.GET)
		public ResponseEntity<List<EgovMap>> selectCrcBank(@RequestParam Map<String, Object> params)throws Exception {

			LOGGER.debug("groupCode : {}", params.get("groupCode"));

			List<EgovMap> codeList = customerService.selectCrcBank(params);

			return ResponseEntity.ok(codeList);
		}


		/**
		 *
		 * Customer Credit Card  정보 수정 창
		 * @param params
		 * @param model
		 * @return
		 * @author 이석희 2017.08.04
		 * */
		@RequestMapping(value = "/updateCustomerCreditCardInfoPop.do")
		public String updateCustomerCreditCardInfoPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

			EgovMap detailcard = null;
			params.put("getparam", params.get("editCustCardId"));
			detailcard = customerService.selectCustomerCreditCardDetailViewPop(params);

			model.addAttribute("detailcard", detailcard);

			return "sales/customer/customerCreditCardEditInfoPop";

		}



		/**
		 *
		 * Customer Bank Account  정보 수정 창
		 * @param params
		 * @param model
		 * @return
		 * @author 이석희 2017.08.04
		 * */
		@RequestMapping(value = "/updateCustomerBankInfoAf.do")
		public ResponseEntity<ReturnMessage> updateCustomerBankInfoAf(@RequestParam Map<String, Object> params, ModelMap model)throws Exception{

			//service
			customerService.updateCustomerBankInfoAf(params);
			// 결과 만들기 예.
			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

			return ResponseEntity.ok(message);
		}


		/**
		 *
		 * Customer Bank Account  정보 수정 창
		 * @param params
		 * @param model
		 * @return
		 * @author 이석희 2017.08.04
		 * */
		@RequestMapping(value = "/updateCustomerCardInfoAf.do")
		public ResponseEntity<ReturnMessage> updateCustomerCardInfoAf(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

			//service
			customerService.updateCustomerCardInfoAf(params);
			// 결과 만들기 예.
			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

			return ResponseEntity.ok(message);

		}


		@RequestMapping(value = "/deleteCustomerAddress.do")
		public ResponseEntity<ReturnMessage> deleteCustomerAddress(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

			//service
			customerService.deleteCustomerAddress(params);
			// 결과 만들기 예.
			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

			return ResponseEntity.ok(message);
		}


		@RequestMapping(value = "/deleteCustomerContact.do")
		public ResponseEntity<ReturnMessage> deleteCustomerContact (@RequestParam Map<String, Object> params) throws Exception{

			//service
			customerService.deleteCustomerContact(params);
			// 결과 만들기 예.
			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

			return ResponseEntity.ok(message);

		}


		@RequestMapping(value = "/deleteCustomerBank.do")
		public ResponseEntity<ReturnMessage> deleteCustomerBank (@RequestParam Map<String, Object> params) throws Exception{

			//service
			customerService.deleteCustomerBank(params);
			// 결과 만들기 예.
			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

			return ResponseEntity.ok(message);
		}


		@RequestMapping(value = "/deleteCustomerCard.do")
		public ResponseEntity<ReturnMessage> deleteCustomerCard (@RequestParam Map<String, Object> params) throws Exception{

			//service
			customerService.deleteCustomerCard(params);
			// 결과 만들기 예.
			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

			return ResponseEntity.ok(message);
		}

		@RequestMapping(value = "/updateCustomerAddressInfoAf.do")
		public ResponseEntity<ReturnMessage> updateCustomerAddressInfoAf(@RequestParam Map<String, Object> params) throws Exception{


			//service
			customerService.updateCustomerAddressInfoAf(params);
			// 결과 만들기 예.
			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

			return ResponseEntity.ok(message);
		}


		/**
		 * Magic Address
		 * @param params
		 * @param model
		 * @return
		 */
		@RequestMapping(value = "/searchMagicAddressPop.do")
		public String searchMagicAddressPop(@RequestParam Map<String, Object>params, ModelMap model){

			if (params.get("extype") != null  && "INS".equals((String)params.get("extype"))){
				model.addAttribute("searchStreet", params.get("isearchSt"));
			}else{
				model.addAttribute("searchStreet", params.get("searchSt"));
			}

			// 데이터 리턴.
			return "sales/customer/customerMagicAddrPop";
		}


		/**
		 * Magic Address
		 * @param params
		 * @param model
		 * @return
		 */
		@RequestMapping(value = "/searchMagicAddressPopJsonList", method = RequestMethod.GET)
		public ResponseEntity<List<EgovMap>> searchMagicAddressPopJsonList(@RequestParam Map<String, Object>params, HttpServletRequest request, ModelMap model) {

			List<EgovMap> searchMagicAddrList = null;
			//searchStreet
			LOGGER.info("##### searchMagicAddrList START #####");
			searchMagicAddrList = customerService.searchMagicAddressPop(params);

			// 데이터 리턴.
			return ResponseEntity.ok(searchMagicAddrList);
		}


		/**
		 * Add new Address(Edit)
		 * @param model
		 * @param params
		 * @return
		 */
		@RequestMapping(value = "/updateCustomerNewAddressPop.do")
		public String updateCustomerNewAddressPop(@RequestParam Map<String, Object> params , ModelMap model) throws Exception{

			model.addAttribute("insCustId", params.get("custId"));

			//Page Param
			model.addAttribute("callParam" , params.get("callParam"));

			return "sales/customer/customerNewAddressPop";
		}


		/**
		 * Add new Contact(Edit)
		 * @param model
		 * @param params
		 * @return
		 */
		@RequestMapping(value = "/updateCustomerNewContactPop.do")
		public String updateCustomerNewContactPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

			model.addAttribute("insCustId", params.get("custId"));

			//Page Param
			model.addAttribute("callParam" , params.get("callParam"));

			return "sales/customer/customerNewContactPop";
		}

		/**
		 * Add new Contact(Edit)
		 * @param model
		 * @param params
		 * @return
		 */
		@RequestMapping(value = "/updateCustomerNewContactPopeSales.do")
		public String updateCustomerNewContactPopeSales(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

			model.addAttribute("insCustId", params.get("custId"));

			//Page Param
			model.addAttribute("callParam" , params.get("callParam"));

			return "sales/customer/customerNewContactPopeSales";
		}


		/**
		 * Add new Contact(Edit)
		 * @param model
		 * @param params
		 * @return
		 */
		@RequestMapping(value = "/updateCustomerNewAddContactPop.do")
		public String updateCustomerNewAddContactPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

			model.addAttribute("insCustId", params.get("custId"));

			//Page Param
			model.addAttribute("callParam" , params.get("callParam"));

			return "sales/customer/customerNewAddContactPop";
		}


		/**
		 * Add new Bank Account(Edit)
		 * @param model
		 * @param params
		 * @return
		 */
		@RequestMapping(value = "/updateCustomerNewBankPop.do")
		public String updateCustomerNewBankPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

			model.addAttribute("insCustId", params.get("custId"));

			return "sales/customer/customerNewBankPop";
		}


		/**
		 * Add new Card Account(Edit)
		 * @param model
		 * @param params
		 * @return
		 */
		@RequestMapping(value = "/updateCustomerNewCardPop.do")
		public String updateCustomerNewCardPop(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

			model.addAttribute("insCustId", params.get("custId"));

			return "sales/customer/customerNewCardPop";
		}


		/**
		 * Add new Address(Edit) After
		 * @param params
		 * @return
		 */
		@RequestMapping(value = "/insertCustomerAddressInfoAf.do")
		public ResponseEntity<ReturnMessage> insertCustomerAddressInfoAf(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

			SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
			params.put("userId", sessionVO.getUserId());
			int custAddId = customerService.insertCustomerAddressInfoAf(params	);

			// 결과 만들기 예.
			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
			message.setData(custAddId);

			return ResponseEntity.ok(message);
		}


		/**
		 * Add new Contact(Edit) After
		 * @param params
		 * @return
		 */
		@RequestMapping(value = "/insertCustomerContactAddAf.do")
		public ResponseEntity<ReturnMessage> insertCustomerContactAddAf(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

			SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
			params.put("userId", sessionVO.getUserId());
			int custCntcId = customerService.insertCustomerContactAddAf(params);

			// 결과 만들기 예.
			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
			message.setData(custCntcId);

			return ResponseEntity.ok(message);
		}

		/**
		 *
		 * Basic Customer Info 등록
		 * @param params
		 * @param model.
		 * @return
		 * @author
		 * */
		@RequestMapping(value = "/insertCareContactInfo.do")
		public ResponseEntity<ReturnMessage> insertCareContactInfo(@RequestParam Map<String, Object> params, ModelMap model, SessionVO sessionVO) {

			int custCareCntId = customerService.getCustCareCntIdSeq();

			params.put("getCustCareCntId", custCareCntId);
			params.put("getCustId", params.get("custId"));
			params.put("custInitial", params.get("cntcInitial"));
			params.put("asCustName", params.get("cntcName"));
			params.put("asTelM", params.get("cntcTelm"));
			params.put("asTelO", params.get("cntcTelo"));
			params.put("asTelR", params.get("cntcTelr"));
			params.put("asTelF", params.get("cntcTelf"));
			params.put("asExt", params.get("cntcExtNo"));
			params.put("asEmail", params.get("cntcEmail"));
			params.put("stusCodeId", SalesConstants.STATUS_ACTIVE);
			params.put("crtUserId", sessionVO.getUserId());
			params.put("updUserId", sessionVO.getUserId());

			customerService.insertCareContactInfo(params);

			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
//			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
			message.setMessage("New contact successfully saved.");
			message.setData(custCareCntId);

			return ResponseEntity.ok(message);
		}

		/**
		 * Add new Bank(Edit) After
		 * @param params
		 * @return
		 */
		@RequestMapping(value = "/insertCustomerBankAddAf.do")
		public ResponseEntity<ReturnMessage> insertCustomerBankAddAf(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{


			SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
			params.put("userId", sessionVO.getUserId());
			customerService.insertCustomerBankAddAf(params	);

			// 결과 만들기 예.
			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

			return ResponseEntity.ok(message);

		}


		/**
		 * Add new Credit Card(Edit) After
		 * @param params
		 * @return
		 */
		@RequestMapping(value = "/insertCustomerCardAddAf.do")
		public ResponseEntity<ReturnMessage> insertCustomerCardAddAf(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

			SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
			params.put("userId", sessionVO.getUserId());
			customerService.insertCustomerCardAddAf(params	);

			// 결과 만들기 예.
			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

			return ResponseEntity.ok(message);

		}


		@RequestMapping(value = "/selectCustomerCopyAddressJson")
		public ResponseEntity<EgovMap> selectCustomerCopyAddressJson(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

			EgovMap addrMap = null;

			addrMap = customerService.selectCustomerAddrDetailViewPop(params);

			return ResponseEntity.ok(addrMap);
		}


		@RequestMapping(value = "/selectCustomerCopyContactJson")
		public ResponseEntity<EgovMap> selectCustomerCopyContactJson(@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

			EgovMap contactMap = null;

			contactMap = customerService.selectCustomerContactDetailViewPop(params);

			return ResponseEntity.ok(contactMap);
		}

		@RequestMapping(value = "/selectCustomerMainAddr")
		public ResponseEntity<EgovMap> selectCustomerMainAddr (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

			EgovMap mainAddidMap = null;
			mainAddidMap = customerService.selectCustomerMainAddr(params);

			return ResponseEntity.ok(mainAddidMap);
		}


		@RequestMapping(value = "/selectCustomerMainContact")
		public ResponseEntity<EgovMap> selectCustomerMainContact (@RequestParam Map<String, Object> params, ModelMap model) throws Exception{

			EgovMap mainContactidMap = null;
			mainContactidMap = customerService.selectCustomerMainContact(params);

			return ResponseEntity.ok(mainContactidMap);
		}


		@RequestMapping(value = "/selectMagicAddressComboList")
		public ResponseEntity<List<EgovMap>>  selectMagicAddressComboList (@RequestParam Map<String, Object> params) throws Exception{

			List<EgovMap> postList = null;

			postList = customerService.selectMagicAddressComboList(params);

			return ResponseEntity.ok(postList);

		}


		@RequestMapping(value = "/getAreaId.do")
		public ResponseEntity<EgovMap> getAreaId(@RequestParam Map<String, Object> params) throws Exception{

			EgovMap areaMap = null;

			areaMap = customerService.getAreaId(params);

			return ResponseEntity.ok(areaMap);
		}



		@RequestMapping(value = "/getNationList")
		public ResponseEntity<List<EgovMap>> getNationList (@RequestParam Map<String, Object> params) throws Exception{

			List<EgovMap> nationList = null;

			nationList = customerService.getNationList(params);

			return ResponseEntity.ok(nationList);

		}


		@RequestMapping(value = "/updateLimitBasicInfo")
		public ResponseEntity<ReturnMessage> updateLimitBasicInfo(@RequestBody Map<String, Object> params) throws Exception{

			//Session
			SessionVO sessionVO = sessionHandler.getCurrentSessionInfo();
			params.put("userId", sessionVO.getUserId());

			LOGGER.info("############################################################");
			LOGGER.info("########  Params : " + params.toString());
			LOGGER.info("############################################################");

			customerService.updateLimitBasicInfo(params);

			// 결과 만들기
			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));

			return ResponseEntity.ok(message);
		}

		@RequestMapping(value = "/customerAddBankAccountMemPop.do")
		public String customerAddBankAccountMemPop(@RequestParam Map<String, Object> params, ModelMap model){

			List<EgovMap> accBankList = customerService.selectAccBank(params);
			model.addAttribute("accBankList", accBankList);
			model.put("custId", params.get("custId"));


			return "sales/customer/customerBankAccountMemPop"	;
		}

}
