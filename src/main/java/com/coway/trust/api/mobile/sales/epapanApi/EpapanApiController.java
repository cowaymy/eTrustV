package com.coway.trust.api.mobile.sales.epapanApi;


import java.io.File;
import java.text.ParseException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.api.mobile.sales.customerApi.CustomerApiForm;
import com.coway.trust.api.mobile.sales.eKeyInApi.EKeyInApiDto;
import com.coway.trust.api.mobile.sales.eKeyInApi.EKeyInApiForm;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.HomecareCmService;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.homecare.sales.order.HcOrderRegisterService;
import com.coway.trust.biz.homecare.sales.order.HcPreOrderService;
import com.coway.trust.biz.homecare.sales.order.vo.HcOrderVO;
import com.coway.trust.biz.sales.customer.CustomerService;
import com.coway.trust.biz.sales.customerApi.CustomerApiService;
import com.coway.trust.biz.sales.order.OrderRegisterService;
import com.coway.trust.biz.sales.order.PreOrderApplication;
import com.coway.trust.biz.sales.order.PreOrderService;
import com.coway.trust.biz.sales.order.vo.PreOrderVO;
import com.coway.trust.biz.sales.promotion.PromotionService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
import com.coway.trust.web.homecare.HomecareConstants;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import springfox.documentation.annotations.ApiIgnore;


/**
 *
 * </pre>
 */
@Api(value = "EpapanApiController", description = "EpapanApiController")
@RestController(value = "EpapanApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/epapanApi")
public class EpapanApiController {


	private static final Logger LOGGER = LoggerFactory.getLogger(EpapanApiController.class);


	@Value("${web.resource.upload.file}")
	private String uploadDir;


	 @Resource(name = "orderRegisterService")
	 private OrderRegisterService orderRegisterService;

	 @Resource(name = "CustomerApiService")
	  private CustomerApiService customerApiService;

     @Resource(name = "customerService")
     private CustomerService customerService;

     @Resource(name = "commonService")
     private CommonService commonService;

 	 @Resource(name = "preOrderService")
 	 private PreOrderService preOrderService;

 	@Resource(name = "hcOrderRegisterService")
	 private HcOrderRegisterService hcOrderRegisterService;

	@Resource(name = "homecareCmService")
	private HomecareCmService homecareCmService;

    @Resource(name = "hcPreOrderService")
    private HcPreOrderService hcPreOrderService;

	@Resource(name = "promotionService")
	private PromotionService promotionService;

 	@Autowired
 	private PreOrderApplication preOrderApplication;

	@ApiOperation(value = "selectPromotionByAppTypeStockESales", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectPromotionByAppTypeStockESales", method = RequestMethod.GET)
	public ResponseEntity <List<EgovMap>> selectPromotionByAppTypeStockESales(@ModelAttribute EpapanApiForm param) throws Exception {


		List<EgovMap> codeList = orderRegisterService.selectPromotionByAppTypeStockESales(EpapanApiForm.createMap(param));
		if(LOGGER.isDebugEnabled()){
			for (int i = 0; i < codeList.size(); i++) {
				LOGGER.debug("codeList    값 : {}", codeList.get(i));
			}
		}

		return ResponseEntity.ok(codeList);

	}




	@ApiOperation(value = "selectProductPromotionPriceByPromoStockID", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectProductPromotionPriceByPromoStockID", method = RequestMethod.GET)
	public ResponseEntity <EgovMap> selectProductPromotionPriceByPromoStockID(@ModelAttribute EpapanApiForm param) throws Exception {

		EgovMap  priceInfo = orderRegisterService.selectProductPromotionPriceByPromoStockID(EpapanApiForm.createMap(param));

	    return ResponseEntity.ok(priceInfo);
	}


	@ApiOperation(value = "searchMagicAddressPopJsonList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/searchMagicAddressPopJsonList", method = RequestMethod.GET)
	public ResponseEntity<List<EgovMap>> searchMagicAddressPopJsonList(@ModelAttribute EpapanApiMagicAddressForm param) {

	    List<EgovMap> searchMagicAddrList = null;
	    // searchStreet
	    LOGGER.info("##### searchMagicAddrList START #####");
	    searchMagicAddrList = customerService.searchMagicAddressPop(EpapanApiMagicAddressForm.createMap(param));

	    // 데이터 리턴.
	    return ResponseEntity.ok(searchMagicAddrList);
	  }

	@ApiOperation(value = "selectMagicAddressComboList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/selectMagicAddressComboList")
	  public ResponseEntity<List<EgovMap>> selectMagicAddressComboList(@ModelAttribute EpapanApiMagicAddressForm param)
	      throws Exception {

	    List<EgovMap> postList = null;

	    postList = customerService.selectMagicAddressComboList(EpapanApiMagicAddressForm.createMap(param));

	    return ResponseEntity.ok(postList);

	  }


	@ApiOperation(value = "selectCrcBank", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/selectCrcBank", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectCrcBank(@ModelAttribute EpapanApiMagicAddressForm param) throws Exception {

	    List<EgovMap> codeList = customerService.selectCrcBank(EpapanApiMagicAddressForm.createMap(param));

	    return ResponseEntity.ok(codeList);
	  }

	@ApiOperation(value = "selectDdlChnl", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/selectDdlChnl", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectDdlChnl(@ModelAttribute EpapanApiMagicAddressForm param) throws Exception {
	    List<EgovMap> codeList = customerService.selectDdlChnl(EpapanApiMagicAddressForm.createMap(param));
	    return ResponseEntity.ok(codeList);
	  }

	@ApiOperation(value = "selectCodeList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/selectCodeList", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectCodeList(@ModelAttribute EpapanApiMagicAddressForm param) {
	    List<EgovMap> codeList = commonService.selectCodeList( EpapanApiMagicAddressForm.createMap(param) );
	    return ResponseEntity.ok( codeList );
	  }

	@ApiOperation(value = "selectAccBank", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/selectAccBank", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectAccBank(@ModelAttribute EpapanApiMagicAddressForm param) throws Exception {

	    List<EgovMap> codeList = customerService.selectAccBank(EpapanApiMagicAddressForm.createMap(param) );
	    return ResponseEntity.ok(codeList);
	  }

	@ApiOperation(value = "getTknId", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/getTknId", method = RequestMethod.GET)
	  public ResponseEntity<Map<String, Object>> getTknId(@ModelAttribute EpapanApiMagicAddressForm param)throws Exception {

	      int tknId = 0;
	      Map<String, Object> result = new HashMap();

	      tknId = (Integer) customerService.getTokenID();
	      result.put("tknId", tknId);
	      result.put("tknRef", EpapanApiMagicAddressForm.createMap(param).get("refId") + StringUtils.leftPad(Integer.toString(tknId), 10, "0"));

	      customerService.insertTokenLogging(result);

	      return ResponseEntity.ok(result);
	  }

	@ApiOperation(value = "getTokenNumber", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/getTokenNumber", method = RequestMethod.GET)
	  public ResponseEntity<ReturnMessage> getTokenNumber(@ModelAttribute EpapanApiMagicAddressForm param)throws Exception {

	      //Map<String, Object> result = new HashMap();
	      Map<String, Object> result = customerService.getTokenNumber(EpapanApiMagicAddressForm.createMap(param));

	      if(result == null){
	          customerService.updateTokenStagingF(EpapanApiMagicAddressForm.createMap(param));
	      }

	      if(result != null && result.get("token") != null){
	          boolean isCreditCardValid = customerService.checkCreditCardValidity(result.get("token").toString());
	          if(isCreditCardValid == false) {
	              customerService.updateTokenStagingF(EpapanApiMagicAddressForm.createMap(param));

	        	  ReturnMessage message = new ReturnMessage();
	              message.setCode(AppConstants.FAIL);
	              message.setData(result);
	              message.setMessage( "This card has marked as \'Transaction Not Allowed\'  <span style='color:red'>(TNA)</span>. Kindly change a new card");

	              return ResponseEntity.ok(message);
	          }
	      }

	      ReturnMessage message = new ReturnMessage();
	      message.setCode(AppConstants.SUCCESS);
	      message.setData(result);
	      message.setMessage("Success");

	      return ResponseEntity.ok(message);
	  }

	@ApiOperation(value = "existingHPCodyMobile", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/existingHPCodyMobile", method = RequestMethod.GET)
	  public ResponseEntity<EgovMap> existingHPCodyMobile(@ModelAttribute EpapanApiMagicAddressForm param) {

		  EgovMap existingHP = customerService.existingHPCodyMobile(EpapanApiMagicAddressForm.createMap(param));

	    return ResponseEntity.ok(existingHP);
	  }



	  @ApiOperation(value = "saveCustomer", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/saveCustomer", method = RequestMethod.POST)
	  public ResponseEntity<CustomerApiForm> saveCustomer(@RequestBody CustomerApiForm param) throws Exception {
	    return ResponseEntity.ok(customerApiService.saveCustomer(param));
	  }

	  @ApiOperation(value = "selectCustomerCreditCardJsonList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/selectCustomerCreditCardJsonList", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectCustomerCreditCardJsonList(@ModelAttribute EpapanApiMagicAddressForm param) throws Exception {

	    List<EgovMap> cardlist = null;
	    LOGGER.info("##### customer Card List Parsing START #####");
	    cardlist = customerService.selectCustomerCreditCardJsonList(EpapanApiMagicAddressForm.createMap(param));

	    return ResponseEntity.ok(cardlist);
	  }

	  @ApiOperation(value = "selectCustomerBankAccJsonList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/selectCustomerBankAccJsonList", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectCustomerBankAccJsonList(@ModelAttribute EpapanApiMagicAddressForm param) throws Exception {

	    List<EgovMap> banklist = null;
	    // params
	    LOGGER.info("##### customer Bank List Parsing START #####");
	    banklist = customerService.selectCustomerBankAccJsonList(EpapanApiMagicAddressForm.createMap(param));

	    return ResponseEntity.ok(banklist);
	  }

	  @ApiOperation(value = "selectCustCntcJsonInfo", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/selectCustCntcJsonInfo", method = RequestMethod.GET)
	  public ResponseEntity<EgovMap> selectCustCntcInfo(@ModelAttribute EpapanApiMagicAddressForm param)
	      throws Exception {

	    EgovMap custAddInfo = customerService.selectCustomerViewMainContact(EpapanApiMagicAddressForm.createMap(param));

	    // 데이터 리턴.
	    return ResponseEntity.ok(custAddInfo);
	  }

	  @ApiOperation(value = "selectCustAddJsonInfo", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/selectCustAddJsonInfo", method = RequestMethod.GET)
	  public ResponseEntity<EgovMap> selectCustAddInfo(@ModelAttribute EpapanApiMagicAddressForm param)
	      throws Exception {

	    // EgovMap custAddInfo = orderRegisterService.selectCustAddInfo(params);
	    EgovMap custAddInfo = customerService.selectCustomerViewMainAddress(EpapanApiMagicAddressForm.createMap(param));
	    /*
	     * if(custAddInfo != null) {
	     * if(CommonUtils.isNotEmpty(custAddInfo.get("postcode"))) {
	     * params.put("postCode", custAddInfo.get("postcode"));
	     *
	     * EgovMap brnchInfo = commonService.selectBrnchIdByPostCode(params);
	     *
	     * custAddInfo.put("brnchId", brnchInfo.get("brnchId")); } }
	     */
	    // 데이터 리턴.
	    return ResponseEntity.ok(custAddInfo);
	  }

	  @ApiOperation(value = "selectCustomerAddressJsonList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/selectCustomerAddressJsonList", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectCustomerAddressJsonList(@ModelAttribute EpapanApiMagicAddressForm param) throws Exception {

	    List<EgovMap> addresslist = null;
	    LOGGER.info("##### customer Address Parsing START #####");
	    addresslist = customerService.selectCustomerAddressJsonList(EpapanApiMagicAddressForm.createMap(param));

	    return ResponseEntity.ok(addresslist);
	  }



	  @ApiOperation(value = "attachFileUpload", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/attachFileUpload", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> attachFileUpload(@ApiIgnore MultipartHttpServletRequest request) throws Exception {

		  LOGGER.debug("request.getFileMap()>>>" + request.getFileMap());
		  LOGGER.debug("request.getParameter()>>>" + request.getParameter("userId"));

			String err = "";
			String code = "";

			String userId = request.getParameter("userId");
			Map<String, Object> ps = new HashMap();

			List<String> seqs = new ArrayList<>();

			LocalDate date = LocalDate.now();
			String year    = String.valueOf(date.getYear());
			String month   = String.format("%02d",date.getMonthValue());

			String subPath = File.separator + "sales"
			               + File.separator + "ekeyin"
			               + File.separator + year
			               + File.separator + month
			               + File.separator + CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT3);

			try{
				 Set set = request.getFileMap().entrySet();
				 Iterator i = set.iterator();

				 while(i.hasNext()) {
				     Map.Entry me = (Map.Entry)i.next();
				     String key = (String)me.getKey();
				     seqs.add(key);
				 }



			//List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadImageFilesWithCompress(request, uploadDir, subPath , AppConstants.UPLOAD_MIN_FILE_SIZE, true);
			List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, subPath , AppConstants.UPLOAD_MIN_FILE_SIZE, true);
			  LOGGER.debug("list>>>" + list);


			ps.put(CommonConstants.USER_ID, userId);
			preOrderApplication.insertPreOrderAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE,  ps, seqs);

			ps.put("attachFiles", list);

			code = AppConstants.SUCCESS;
			}catch(ApplicationException e){
				err = e.getMessage();
				code = AppConstants.FAIL;
			}

			ReturnMessage message = new ReturnMessage();
			message.setCode(code);
			message.setData(ps);
			message.setMessage(err);

			return ResponseEntity.ok(message);
		}

	  @ApiOperation(value = "registerPreOrder", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/registerPreOrder", method = RequestMethod.POST)
		public ResponseEntity<ReturnMessage> registerPreOrder(@RequestBody PreOrderVO preOrderVO, @ApiIgnore HttpServletRequest request) throws Exception {


		  	SessionVO sessionVO = new SessionVO();
		  	sessionVO.setUserId(preOrderVO.getCrtUserId());

		  	preOrderVO.setChnnl(2);
			preOrderService.insertPreOrder(preOrderVO, sessionVO);

			String msg = "", appTypeName = "";

			switch(preOrderVO.getAppTypeId()) {
	    		case SalesConstants.APP_TYPE_CODE_ID_RENTAL :
	    			appTypeName = SalesConstants.APP_TYPE_CODE_RENTAL_FULL;
	    			break;
	    		case SalesConstants.APP_TYPE_CODE_ID_OUTRIGHT :
	    			appTypeName = SalesConstants.APP_TYPE_CODE_OUTRIGHT_FULL;
	    			break;
	    		case SalesConstants.APP_TYPE_CODE_ID_INSTALLMENT :
	    			appTypeName = SalesConstants.APP_TYPE_CODE_INSTALLMENT_FULL;
	    			break;
	    		case SalesConstants.APP_TYPE_CODE_ID_SPONSOR :
	    			appTypeName = SalesConstants.APP_TYPE_CODE_SPONSOR_FULL;
	    			break;
	    		case SalesConstants.APP_TYPE_CODE_ID_SERVICE :
	    			appTypeName = SalesConstants.APP_TYPE_CODE_SERVICE_FULL;
	    			break;
	    		case SalesConstants.APP_TYPE_CODE_ID_EDUCATION :
	    			appTypeName = SalesConstants.APP_TYPE_CODE_EDUCATION_FULL;
	    			break;
	    		case SalesConstants.APP_TYPE_CODE_ID_FREE_TRIAL :
	    			appTypeName = SalesConstants.APP_TYPE_CODE_FREE_TRIAL_FULL;
	    			break;
	    		case SalesConstants.APP_TYPE_CODE_ID_OUTRIGHTPLUS :
	    			appTypeName = SalesConstants.APP_TYPE_CODE_OUTRIGHTPLUS_FULL;
	    			break;
	    		default :
	    			break;
	    	}

	        msg += "Order successfully saved.<br />";
	        msg += "SOF No : " + preOrderVO.getSofNo() + "<br />";
	        msg += "Application Type : " + appTypeName + "<br />";

			// 결과 만들기
			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
//			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
			message.setMessage(msg);
			message.setData(preOrderVO.getSofNo());

			return ResponseEntity.ok(message);
		}

	  @ApiOperation(value = "selectExistSofNo", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/selectExistSofNo")
		public ResponseEntity<EgovMap> selectExistSofNo(@ModelAttribute EpapanApiMagicAddressForm param) {

			int cnt = preOrderService.selectExistSofNo(EpapanApiMagicAddressForm.createMap(param));

			EgovMap result = new EgovMap();

			result.put("IS_EXIST", cnt > 0 ? "true" : "false");

			return ResponseEntity.ok(result);
		}

	  @ApiOperation(value = "selectHcProductCodeList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	   @RequestMapping(value = "/selectHcProductCodeList", method = RequestMethod.GET)
		public ResponseEntity<List<EgovMap>> selectProductCodeList(@ModelAttribute EpapanApiMagicAddressForm param) {
			// Homecare Product List
			List<EgovMap> codeList = hcOrderRegisterService.selectHcProductCodeList(EpapanApiMagicAddressForm.createMap(param));

			return ResponseEntity.ok(codeList);
		}

	  @ApiOperation(value = "checkIfIsAcInstallationProductCategoryCode", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
		@RequestMapping(value = "/checkIfIsAcInstallationProductCategoryCode")
		public ResponseEntity<ReturnMessage> checkIfIsAcInstallationProductCategoryCode(@ModelAttribute EpapanApiMagicAddressForm param) {
			ReturnMessage message = new ReturnMessage();
			int result = homecareCmService.checkIfIsAcInstallationProductCategoryCode(EpapanApiMagicAddressForm.createMap(param));
			message.setCode("1");
			message.setData(result);
		    return ResponseEntity.ok(message);
		}

	  @ApiOperation(value = "checkProductSize", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
		@RequestMapping(value = "/checkProductSize")
		public ResponseEntity<ReturnMessage> checkProductSize(@ModelAttribute EpapanApiMagicAddressForm param) {
			boolean chkSize = hcOrderRegisterService.checkProductSize(EpapanApiMagicAddressForm.createMap(param));

			// 결과 만들기
			ReturnMessage message = new ReturnMessage();
			if(chkSize) {
				message.setCode(AppConstants.SUCCESS);
				message.setMessage("Success!");

			} else {
				message.setCode(AppConstants.FAIL);
				message.setMessage("Product Size is different.");
			}

			return ResponseEntity.ok(message);
		}

	  @ApiOperation(value = "selectStockPriceJsonInfo", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/selectStockPriceJsonInfo", method = RequestMethod.GET)
	  public ResponseEntity<EgovMap> selectStockPrice(@ModelAttribute EpapanApiMagicAddressForm param)
	      throws Exception {

	    EgovMap priceInfo = orderRegisterService.selectStockPrice(EpapanApiMagicAddressForm.createMap(param));

	    // 데이터 리턴.
	    return ResponseEntity.ok(priceInfo);
	  }

	  @ApiOperation(value = "selectPrevOrderNoList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/selectPrevOrderNoList", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectPrevOrderNoList(@ModelAttribute EpapanApiMagicAddressForm param) {
	    List<EgovMap> result = orderRegisterService.selectPrevOrderNoList(EpapanApiMagicAddressForm.createMap(param));
	    return ResponseEntity.ok(result);
	  }

	  @ApiOperation(value = "registerHcPreOrder", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/registerHcPreOrder", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> registerHcPreOrder(@RequestBody PreOrderVO preOrderVO, @ApiIgnore HttpServletRequest request) throws Exception {
			String appTypeStr = HomecareConstants.cnvAppTypeName(preOrderVO.getAppTypeId());

		  	SessionVO sessionVO = new SessionVO();
		  	sessionVO.setUserId(preOrderVO.getCrtUserId());

		  	preOrderVO.setChnnl(2);
			hcPreOrderService.registerHcPreOrder(preOrderVO, sessionVO);

			HcOrderVO hcOrderVO = preOrderVO.getHcOrderVO();

			String msg = "Order successfully saved.<br />";

			if(!"".equals(CommonUtils.nvl(hcOrderVO.getMatPreOrdId())) && !"0".equals(CommonUtils.nvl(hcOrderVO.getMatPreOrdId()))) {
				msg += "Pre Order Number(Mattres) : " + hcOrderVO.getMatPreOrdId() + "<br />";
			}
			if(!"".equals(CommonUtils.nvl(hcOrderVO.getFraPreOrdId())) && !"0".equals(CommonUtils.nvl(hcOrderVO.getFraPreOrdId()))) {
				msg += "Pre Order Number(Frame) : "   + hcOrderVO.getFraPreOrdId() + "<br />";
			}
			msg += "Bundle Number : " + hcOrderVO.getBndlNo() + "<br />";
			msg += "Application Type : " + appTypeStr + "<br />";

			// 결과 만들기
			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(msg);
			message.setData(hcOrderVO.getBndlNo());

			return ResponseEntity.ok(message);
		}

	  @ApiOperation(value = "chkExtradeScheduleEpapan", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/chkExtradeScheduleEpapan", method = RequestMethod.GET)
	  public ResponseEntity<Integer> chkExtradeScheduleEpapan(@ModelAttribute EpapanApiMagicAddressForm param) throws Exception {
	    int result = preOrderService.chkExtradeScheduleEpapan();

	    return ResponseEntity.ok(result);
	  }

	  @ApiOperation(value = "selectHcPreOrderList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	    @RequestMapping(value = "/selectHcPreOrderList",  method = RequestMethod.GET)
		public ResponseEntity<List<EgovMap>> selectHcPreOrderList(@ModelAttribute EpapanApiMagicAddressForm param) {


		  	System.out.println(param.toString());

			List<EgovMap> result = hcPreOrderService.selectHcPreOrderList(EpapanApiMagicAddressForm.createMap(param));

			return ResponseEntity.ok(result);
		}

	  @ApiOperation(value = "selectPreOrderList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
		@RequestMapping(value = "/selectPreOrderList",  method = RequestMethod.GET)
		public ResponseEntity<List<EgovMap>> selectPreOrderList(@ModelAttribute EpapanApiMagicAddressForm param) {

			List<EgovMap> result = preOrderService.selectPreOrderList(EpapanApiMagicAddressForm.createMap(param));

			return ResponseEntity.ok(result);
		}

	  @ApiOperation(value = "selectPromotionFreeGiftList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
		@RequestMapping(value = "/selectPromotionFreeGiftList", method = RequestMethod.GET)
		public ResponseEntity<List<EgovMap>> selectPromotionFreeGiftList(@ModelAttribute EpapanApiMagicAddressForm param) {

			List<EgovMap> resultList = promotionService.selectPromotionFreeGiftList(EpapanApiMagicAddressForm.createMap(param));

			return ResponseEntity.ok(resultList);
		}

	  @ApiOperation(value = "insertCustomerAddressInfoAf", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/insertCustomerAddressInfoAf", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> insertCustomerAddressInfoAf(@RequestBody EpapanApiMagicAddressForm param) throws Exception {


	    int custAddrExist = customerService.selectCustomerAddressJsonList(EpapanApiMagicAddressForm.createMap(param)).size();

	    param.setStusId( custAddrExist < 1 ? "9" : "1");
	    int custAddId = customerService.insertCustomerAddressInfoAf(EpapanApiMagicAddressForm.createMap(param));

	    ReturnMessage message = new ReturnMessage();
	    message.setCode(AppConstants.SUCCESS);
	    message.setMessage("Success!");
	    message.setData(custAddId);

	    return ResponseEntity.ok(message);
	  }

	  @ApiOperation(value = "insertCustomerBankAddAf", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/insertCustomerBankAddAf")
	  public ResponseEntity<ReturnMessage> insertCustomerBankAddAf(@RequestBody EpapanApiMagicAddressForm param)
	      throws Exception {

	    customerService.insertCustomerBankAddAf(EpapanApiMagicAddressForm.createMap(param));

	    ReturnMessage message = new ReturnMessage();
	    message.setCode(AppConstants.SUCCESS);
	    message.setMessage("Success!");

	    return ResponseEntity.ok(message);
	  }

	  @ApiOperation(value = "insertCustomerCardAddAf", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/insertCustomerCardAddAf")
	  public ResponseEntity<ReturnMessage> insertCustomerCardAddAf(@RequestBody EpapanApiMagicAddressForm param)
	      throws Exception {

	    int custCrcId = customerService.getCustCrcId();
	    param.setCustCrcId(String.valueOf(custCrcId));

	    customerService.insertCustomerCardAddAf(EpapanApiMagicAddressForm.createMap(param)); //FRANGO CHECk
		customerService.tokenCrcUpdate1(EpapanApiMagicAddressForm.createMap(param));

	    // 결과 만들기 예.
	    ReturnMessage message = new ReturnMessage();
	    message.setCode(AppConstants.SUCCESS);
	    message.setMessage("Success!");

	    return ResponseEntity.ok(message);

	  }

	  @ApiOperation(value = "getNationList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/getNationList")
	  public ResponseEntity<List<EgovMap>> getNationList(@RequestBody EpapanApiMagicAddressForm param) throws Exception {

	    List<EgovMap> nationList = null;

	    nationList = customerService.getNationList(EpapanApiMagicAddressForm.createMap(param));

	    return ResponseEntity.ok(nationList);

	  }

	  @ApiOperation(value = "insertCustomerContactAddAf", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/insertCustomerContactAddAf")
	  public ResponseEntity<ReturnMessage> insertCustomerContactAddAf(@RequestBody EpapanApiMagicAddressForm param) throws Exception {

	    int custCntcId = customerService.insertCustomerContactAddAf(EpapanApiMagicAddressForm.createMap(param));

	    ReturnMessage message = new ReturnMessage();
	    message.setCode(AppConstants.SUCCESS);
	    message.setMessage("Success!");
	    message.setData(custCntcId);

	    return ResponseEntity.ok(message);
	  }

	  @ApiOperation(value = "selectCustomerContactJsonList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/selectCustomerContactJsonList", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectCustomerContactJsonList(@ModelAttribute EpapanApiMagicAddressForm param) throws Exception {

	    List<EgovMap> contactlist = null;
	    LOGGER.info("##### customer Contact Parsing START #####");
	    contactlist = customerService.selectCustomerContactJsonList(EpapanApiMagicAddressForm.createMap(param));
	    return ResponseEntity.ok(contactlist);
	  }

	  @ApiOperation(value = "preOrderModifyPop", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/preOrderModifyPop", method = RequestMethod.GET)
	  public ResponseEntity<EgovMap> preOrderModifyPop(@ModelAttribute EpapanApiMagicAddressForm param) throws Exception {

	    //[Tap]Basic Info
		EgovMap model = new EgovMap();
		EgovMap result = preOrderService.selectPreOrderInfo(EpapanApiMagicAddressForm.createMap(param));

//		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);
//
//		model.put("toDay", toDay);
		model.put("preOrderInfo", result);

		EgovMap checkExtradeSchedule = preOrderService.checkExtradeSchedule();

        String dayFrom = "", dayTo = "";

        if(checkExtradeSchedule!=null){
        	dayFrom = checkExtradeSchedule.get("startDate").toString();
        	dayTo = checkExtradeSchedule.get("endDate").toString();
        }
        else{
        	dayFrom = "20"; // default 20-{month-1}
       	  dayTo = "31"; // default LAST DAY OF THE MONTH
        }

		String bfDay = CommonUtils.changeFormat(CommonUtils.getCalMonth(-1), SalesConstants.DEFAULT_DATE_FORMAT3,
					SalesConstants.DEFAULT_DATE_FORMAT1);
		String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

		model.put("hsBlockDtFrom", dayFrom);
		model.put("hsBlockDtTo", dayTo);

		model.put("bfDay", bfDay);
		model.put("toDay", toDay);
		model.put("userType", EpapanApiMagicAddressForm.createMap(param).get("userTypeId"));
        model.put("codeList_562", commonService.selectCodeList("562", "CODE_NAME"));
	    return ResponseEntity.ok(model);
	  }

	  @ApiOperation(value = "selectPreOrderModifyDataList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/selectPreOrderModifyDataList",  method = RequestMethod.GET)
		public ResponseEntity<EgovMap> selectPreOrderModifyDataList(@ModelAttribute EpapanApiMagicAddressForm param) throws Exception {
			// Search Pre Order Info
		    EgovMap model = new EgovMap();
			Map<String, Object> ps = new HashMap();

			EgovMap preOrderInfo = null;
			// 매핑테이블 조회. - HMC0011D
			EgovMap hcPreOrdInfo = hcPreOrderService.selectHcPreOrderInfo(EpapanApiMagicAddressForm.createMap(param));
			EgovMap matOrderInfo = null;
			EgovMap frmOrderInfo = null;

			String matPreOrdId = CommonUtils.nvl(hcPreOrdInfo.get("matPreOrdId"));
			String fraPreOrdId =  CommonUtils.nvl(hcPreOrdInfo.get("fraPreOrdId"));

			if(!"".equals(matPreOrdId) && !"0".equals(matPreOrdId)) {
				// Mattress Order Info
				ps.put("preOrdId", matPreOrdId);
				matOrderInfo = preOrderService.selectPreOrderInfo(ps);
				preOrderInfo = preOrderService.selectPreOrderInfo(ps);
			}
			if(!"".equals(fraPreOrdId) && !"0".equals(fraPreOrdId)) {
	    		// Frame Order Info
				ps.put("preOrdId", fraPreOrdId);
	    		frmOrderInfo = preOrderService.selectPreOrderInfo(ps);
			}

			//model.put("toDay", CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1));

		   EgovMap checkExtradeSchedule = preOrderService.checkExtradeSchedule();

	        String dayFrom = "", dayTo = "";

	        if(checkExtradeSchedule!=null){
	        	dayFrom = checkExtradeSchedule.get("startDate").toString();
	        	dayTo = checkExtradeSchedule.get("endDate").toString();
	        }
	        else{
	        	dayFrom = "20"; // default 20-{month-1}
	       	  dayTo = "31"; // default LAST DAY OF THE MONTH
	        }

			String bfDay = CommonUtils.changeFormat(CommonUtils.getCalMonth(-1), SalesConstants.DEFAULT_DATE_FORMAT3,
						SalesConstants.DEFAULT_DATE_FORMAT1);
			String toDay = CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT1);

			model.put("hsBlockDtFrom", dayFrom);
			model.put("hsBlockDtTo", dayTo);

			model.put("bfDay", bfDay);
			model.put("toDay", toDay);

			model.put("preOrderInfo", preOrderInfo);
			model.put("hcPreOrdInfo", hcPreOrdInfo);
			model.put("preMatOrderInfo", matOrderInfo);
			model.put("preFrmOrderInfo", frmOrderInfo);

	        model.put("codeList_562", commonService.selectCodeList("562", "CODE_NAME"));

	        return ResponseEntity.ok(model);
		}

	  @ApiOperation(value = "attachFileUpdate", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/attachFileUpdate", method = RequestMethod.POST)
	  public ResponseEntity<ReturnMessage> attachFileUpdate(@ApiIgnore MultipartHttpServletRequest request, @ModelAttribute EpapanApiMagicAddressForm param) throws Exception {

		String userId = request.getParameter("userId");
		Map<String, Object> ps = new HashMap();
		String err = "";
		String code = "";
		List<String> seqs = new ArrayList<>();

		LocalDate date = LocalDate.now();
	    String year    = String.valueOf(date.getYear());
	    String month   = String.format("%02d",date.getMonthValue());

	    String subPath = File.separator + "sales"
	                   + File.separator + "ekeyin"
	                   + File.separator + year
	                   + File.separator + month
	                   + File.separator + CommonUtils.getFormattedString(SalesConstants.DEFAULT_DATE_FORMAT3);

			try{
				 Set set = request.getFileMap().entrySet();
				 Iterator i = set.iterator();

				 while(i.hasNext()) {
				     Map.Entry me = (Map.Entry)i.next();
				     String key = (String)me.getKey();
				     seqs.add(key);
				 }

				//List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadImageFilesWithCompress(request, uploadDir, subPath , AppConstants.UPLOAD_MIN_FILE_SIZE, true);
				List<EgovFormBasedFileVo> list = EgovFileUploadUtil.uploadFiles(request, uploadDir, subPath , AppConstants.UPLOAD_MIN_FILE_SIZE, true);
				ps.put(CommonConstants.USER_ID, userId);


				preOrderApplication.updatePreOrderAttachBiz(FileVO.createList(list), FileType.WEB_DIRECT_RESOURCE, EpapanApiMagicAddressForm.createMap(param), seqs);

				ps.put("attachFiles", list);
				code = AppConstants.SUCCESS;
			}catch(ApplicationException e){
				err = e.getMessage();
				code = AppConstants.FAIL;
			}

			ReturnMessage message = new ReturnMessage();
			message.setCode(code);
			message.setData(ps);
			message.setMessage(err);

			return ResponseEntity.ok(message);
		}

	  @ApiOperation(value = "modifyPreOrder", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/modifyPreOrder", method = RequestMethod.POST)
		public ResponseEntity<ReturnMessage> modifyPreOrder(@RequestBody PreOrderVO preOrderVO) throws Exception {

		  SessionVO sessionVO = new SessionVO();
		  sessionVO.setUserId(preOrderVO.getCrtUserId());
		  preOrderService.updatePreOrder(preOrderVO, sessionVO);

		  String msg = "", appTypeName = "";

			switch(preOrderVO.getAppTypeId()) {
	    		case SalesConstants.APP_TYPE_CODE_ID_RENTAL :
	    			appTypeName = SalesConstants.APP_TYPE_CODE_RENTAL_FULL;
	    			break;
	    		case SalesConstants.APP_TYPE_CODE_ID_OUTRIGHT :
	    			appTypeName = SalesConstants.APP_TYPE_CODE_OUTRIGHT_FULL;
	    			break;
	    		case SalesConstants.APP_TYPE_CODE_ID_INSTALLMENT :
	    			appTypeName = SalesConstants.APP_TYPE_CODE_INSTALLMENT_FULL;
	    			break;
	    		case SalesConstants.APP_TYPE_CODE_ID_SPONSOR :
	    			appTypeName = SalesConstants.APP_TYPE_CODE_SPONSOR_FULL;
	    			break;
	    		case SalesConstants.APP_TYPE_CODE_ID_SERVICE :
	    			appTypeName = SalesConstants.APP_TYPE_CODE_SERVICE_FULL;
	    			break;
	    		case SalesConstants.APP_TYPE_CODE_ID_EDUCATION :
	    			appTypeName = SalesConstants.APP_TYPE_CODE_EDUCATION_FULL;
	    			break;
	    		case SalesConstants.APP_TYPE_CODE_ID_FREE_TRIAL :
	    			appTypeName = SalesConstants.APP_TYPE_CODE_FREE_TRIAL_FULL;
	    			break;
	    		case SalesConstants.APP_TYPE_CODE_ID_OUTRIGHTPLUS :
	    			appTypeName = SalesConstants.APP_TYPE_CODE_OUTRIGHTPLUS_FULL;
	    			break;
	    		default :
	    			break;
	    	}

	        msg += "Order successfully updated.<br />";
	        msg += "SOF No : " + preOrderVO.getSofNo() + "<br />";
	        msg += "Application Type : " + appTypeName + "<br />";

			// 결과 만들기
			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
//			message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
			message.setMessage(msg);

			return ResponseEntity.ok(message);
		}

	  @ApiOperation(value = "selectAttachList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/selectAttachList", method = RequestMethod.GET)
		public ResponseEntity<List<EgovMap>> getAttachList(@ModelAttribute EpapanApiMagicAddressForm param) {
			List<EgovMap> attachList = preOrderService.getAttachList(EpapanApiMagicAddressForm.createMap(param)) ;

			return ResponseEntity.ok( attachList);
		}

	  @ApiOperation(value = "updateHcPreOrder", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/updateHcPreOrder", method = RequestMethod.POST)
		public ResponseEntity<ReturnMessage> updateHcPreOrder(@RequestBody PreOrderVO preOrderVO) throws Exception {

		    SessionVO sessionVO = new SessionVO();
		    sessionVO.setUserId(preOrderVO.getCrtUserId());
		    hcPreOrderService.updateHcPreOrder(preOrderVO, sessionVO);

			String msg = "Order successfully saved.<br />";

			if(!"".equals(CommonUtils.nvl(preOrderVO.getHcOrderVO().getMatPreOrdId())) && !"0".equals(CommonUtils.nvl(preOrderVO.getHcOrderVO().getMatPreOrdId()))) {
				msg += "Pre Order Number(Mattres) : " + preOrderVO.getHcOrderVO().getMatPreOrdId() + "<br />";
			}
			if(!"".equals(CommonUtils.nvl(preOrderVO.getHcOrderVO().getFraPreOrdId())) && !"0".equals(CommonUtils.nvl(preOrderVO.getHcOrderVO().getFraPreOrdId()))) {
				msg += "Pre Order Number(Frame) : "   + preOrderVO.getHcOrderVO().getFraPreOrdId() + "<br />";
			}
			msg += "Application Type : " + HomecareConstants.cnvAppTypeName(preOrderVO.getAppTypeId()) + "<br />";

			// 결과 만들기
			ReturnMessage message = new ReturnMessage();
			message.setCode(AppConstants.SUCCESS);
			message.setMessage(msg);

			return ResponseEntity.ok(message);
		}

	  @ApiOperation(value = "selectPwpOrderNoList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/selectPwpOrderNoList", method = RequestMethod.GET)
	  public ResponseEntity<List<EgovMap>> selectPwpOrderNoList(@ModelAttribute EpapanApiMagicAddressForm param) {
	    List<EgovMap> result = hcOrderRegisterService.selectPwpOrderNoList(EpapanApiMagicAddressForm.createMap(param));
	    return ResponseEntity.ok(result);
	  }

	  @ApiOperation(value = "checkPwpOrderId", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/checkPwpOrderId", method = RequestMethod.GET)
	  public ResponseEntity<EgovMap> checkPwpOrderId(@ModelAttribute EpapanApiMagicAddressForm param) throws ParseException {
	    EgovMap RESULT = hcOrderRegisterService.checkPwpOrderId(EpapanApiMagicAddressForm.createMap(param));
	    return ResponseEntity.ok(RESULT);
	  }

	  @ApiOperation(value = "checkOldOrderId", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/checkOldOrderId", method = RequestMethod.GET)
	  public ResponseEntity<EgovMap> selectOldOrderId(@ModelAttribute EpapanApiMagicAddressForm param) throws Exception {
	    EgovMap RESULT;
	    if (EpapanApiMagicAddressForm.createMap(param).get("exTrade").equals("2")) {
	      RESULT = orderRegisterService.checkOldOrderIdICare(EpapanApiMagicAddressForm.createMap(param));
	    } else {
	      RESULT = orderRegisterService.checkOldOrderId(EpapanApiMagicAddressForm.createMap(param));
	    }
	    return ResponseEntity.ok(RESULT);
	  }

	  @ApiOperation(value = "checkExtradeWithPromoOrder", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	  @RequestMapping(value = "/checkExtradeWithPromoOrder", method = RequestMethod.GET)
	  public ResponseEntity<ReturnMessage> checkExtradeWithPromoOrder(@RequestParam Map<String, Object> params) {

		    ReturnMessage result = orderRegisterService.checkExtradeWithPromoOrder(params);
		    return ResponseEntity.ok(result);
	  }

}
