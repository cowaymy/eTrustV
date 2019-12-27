package com.coway.trust.api.mobile.payment.fundTransferApi;

import java.util.List;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.fundTransferApi.FundTransferApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;


/**
 * @ClassName : FundTransferApiController.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 10. 21.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Api(value = "FundTransferApiController", description = "FundTransferApiController")
@RestController(value = "FundTransferApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/fundTransferApi")
public class FundTransferApiController {



	private static final Logger LOGGER = LoggerFactory.getLogger(FundTransferApiController.class);



	@Resource(name = "FundTransferApiService")
	private FundTransferApiService fundTransferApiService;



	@ApiOperation(value = "selectReasonList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectReasonList", method = RequestMethod.GET)
	public ResponseEntity<List<FundTransferApiDto>> selectReasonList() throws Exception {
		List<EgovMap> selectReasonList = fundTransferApiService.selectReasonList();
		if(LOGGER.isDebugEnabled()){
			for (int i = 0; i < selectReasonList.size(); i++) {
				LOGGER.debug("selectReasonList    값 : {}", selectReasonList.get(i));
			}
		}
		return ResponseEntity.ok(selectReasonList.stream().map(r -> FundTransferApiDto.create(r)).collect(Collectors.toList()));
	}



    @ApiOperation(value = "selectFundTransfer", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/selectFundTransfer", method = RequestMethod.GET)
    public ResponseEntity<FundTransferApiDto> selectFundTransfer(@ModelAttribute FundTransferApiForm param) throws Exception {
        FundTransferApiDto selectFundTransfer = fundTransferApiService.selectFundTransfer(param);
        return ResponseEntity.ok(selectFundTransfer);
    }



    @ApiOperation(value = "saveFundTransfer", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/saveFundTransfer", method = RequestMethod.POST)
    public ResponseEntity<FundTransferApiForm> saveFundTransfer(@RequestBody FundTransferApiForm param) throws Exception {
        FundTransferApiForm saveFundTransfer = fundTransferApiService.saveFundTransfer(param);
        return ResponseEntity.ok(saveFundTransfer);
    }
}
