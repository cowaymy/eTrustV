package com.coway.trust.api.mobile.payment.requestRefundApi;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.requestRefundApi.RequestRefundApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;


/**
 * @ClassName : RequestRefundApiController.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 10. 21.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Api(value = "RequestRefundApiController", description = "RequestRefundApiController")
@RestController(value = "RequestRefundApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/requestRefundApi")
public class RequestRefundApiController {



	private static final Logger LOGGER = LoggerFactory.getLogger(RequestRefundApiController.class);



	@Resource(name = "RequestRefundApiService")
	private RequestRefundApiService requestRefundApiService;



    @ApiOperation(value = "selectCodeList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/selectCodeList", method = RequestMethod.GET)
    public ResponseEntity<Map<String, List<EgovMap>>> selectCodeList() throws Exception {
        Map<String, List<EgovMap>> selectCodeList = requestRefundApiService.selectCodeList();
        if(LOGGER.isDebugEnabled()){
            for (int i = 0; i < selectCodeList.size(); i++) {
                LOGGER.debug("selectCodeList    값 : {}", selectCodeList.get(i));
            }
        }
        return ResponseEntity.ok(selectCodeList);
    }



    @ApiOperation(value = "saveRequestRefund", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/saveRequestRefund", method = RequestMethod.POST)
    public ResponseEntity<RequestRefundApiDto> saveRequestRefund(@RequestBody RequestRefundApiDto param) throws Exception {
        return ResponseEntity.ok(requestRefundApiService.saveRequestRefund(param));
    }
}
