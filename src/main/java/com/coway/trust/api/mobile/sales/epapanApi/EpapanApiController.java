package com.coway.trust.api.mobile.sales.epapanApi;


import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.order.OrderRegisterService;

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




}
