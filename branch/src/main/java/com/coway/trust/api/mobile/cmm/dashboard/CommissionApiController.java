package com.coway.trust.api.mobile.cmm.dashboard;

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
import com.coway.trust.biz.cmm.dashboard.CommissionApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;


/**
 * @ClassName : CommissionApiController.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 11. 05.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Api(value = "CommissionApiController", description = "CommissionApiController")
@RestController(value = "CommissionApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/commissionApi")
public class CommissionApiController {



    private static final Logger LOGGER = LoggerFactory.getLogger(CommissionApiController.class);



	@Resource(name = "CommissionApiService")
	private CommissionApiService commissionApiService;



    @ApiOperation(value = "selectCommissionDashboard", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/selectCommissionDashboard", method = RequestMethod.GET)
    public ResponseEntity<List<CommissionApiDto>> selectCommissionDashboard(@ModelAttribute CommissionApiForm param) throws Exception {
        List<EgovMap> selectCommissionDashboard = commissionApiService.selectCommissionDashboard(param);
        if(LOGGER.isDebugEnabled()){
            for (int i = 0; i < selectCommissionDashboard.size(); i++) {
                    LOGGER.debug("selectCommissionDashboard    값 : {}", selectCommissionDashboard.get(i));
            }
        }
        return ResponseEntity.ok(selectCommissionDashboard.stream().map(r -> CommissionApiDto.create(r)).collect(Collectors.toList()));
    }
}
