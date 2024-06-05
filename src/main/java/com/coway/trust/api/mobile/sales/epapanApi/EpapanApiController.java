package com.coway.trust.api.mobile.sales.epapanApi;


import java.io.File;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.common.CommonConstants;
import com.coway.trust.api.mobile.sales.customerApi.CustomerApiForm;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.sales.customer.CustomerService;
import com.coway.trust.biz.sales.customerApi.CustomerApiService;
import com.coway.trust.biz.sales.order.OrderRegisterService;
import com.coway.trust.biz.sales.order.PreOrderApplication;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.file.EgovFileUploadUtil;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.util.EgovFormBasedFileVo;
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
			String err = "";
			String code = "";
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


			ps.put(CommonConstants.USER_ID, 138);
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

}
