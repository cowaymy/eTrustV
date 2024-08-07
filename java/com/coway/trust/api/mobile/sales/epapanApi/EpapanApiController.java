package com.coway.trust.api.mobile.sales.epapanApi;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.sales.customer.CustomerService;
import com.coway.trust.biz.sales.order.OrderRegisterService;
import com.coway.trust.cmmn.model.ReturnMessage;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;


/**
 *
 * </pre>
 */
@Api(value = "EpapanApiController", description = "EpapanApiController")
@RestController(value = "EpapanApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/epapanApi")
public class EpapanApiController {


	private static final Logger LOGGER = LoggerFactory.getLogger(EpapanApiController.class);



	 @Resource(name = "orderRegisterService")
	 private OrderRegisterService orderRegisterService;


     @Resource(name = "customerService")
     private CustomerService customerService;

     @Resource(name = "commonService")
     private CommonService commonService;

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

}
