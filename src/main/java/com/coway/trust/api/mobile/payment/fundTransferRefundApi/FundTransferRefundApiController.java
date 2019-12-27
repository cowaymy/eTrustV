package com.coway.trust.api.mobile.payment.fundTransferRefundApi;

import java.util.List;
import java.util.stream.Collectors;

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
import com.coway.trust.biz.payment.fundTransferRefundApi.FundTransferRefundApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;


/**
 * @ClassName : FundTransferRefundApiController.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 10. 10.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Api(value = "FundTransferRefundApiController", description = "FundTransferRefundApiController")
@RestController(value = "FundTransferRefundApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/fundTransferRefundApi")
public class FundTransferRefundApiController {



	private static final Logger LOGGER = LoggerFactory.getLogger(FundTransferRefundApiController.class);



	@Resource(name = "FundTransferRefundApiService")
	private FundTransferRefundApiService fundTransferRefundApiService;



	@ApiOperation(value = "selectFundTransferRefundList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectFundTransferRefundList", method = RequestMethod.GET)
	public ResponseEntity<List<FundTransferRefundApiDto>> selectFundTransferRefundList(@ModelAttribute FundTransferRefundApiForm param) throws Exception {
		List<EgovMap> selectFundTransferRefundList = fundTransferRefundApiService.selectFundTransferRefundList(param);
		if(LOGGER.isDebugEnabled()){
			for (int i = 0; i < selectFundTransferRefundList.size(); i++) {
				LOGGER.debug("selectFundTransferRefundList    값 : {}", selectFundTransferRefundList.get(i));
			}
		}
		return ResponseEntity.ok(selectFundTransferRefundList.stream().map(r -> FundTransferRefundApiDto.create(r)).collect(Collectors.toList()));
	}
}
