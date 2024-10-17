package com.coway.trust.api.project.selfcarePortal;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.coway.trust.AppConstants;
import com.coway.trust.biz.api.SelfcarePortalApiService;
import com.coway.trust.biz.api.vo.selfcarePortal.VerifyOderNoReqForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

@Api(value = "SelfcarePortalApiController", description = "SelfcarePortalApiController")
@RestController(value = "SelfcarePortalApiController")
@RequestMapping(AppConstants.WEB_API_BASE_URI + "/cp")
public class SelfcarePortalApiController
{
    private static final Logger LOGGER = LoggerFactory.getLogger( SelfcarePortalApiController.class );

    @Resource(name="selfcarePortalApiService")
    private SelfcarePortalApiService selfcarePortalApiService;

    @ApiOperation(value = "/getProductDetail", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/getProductDetail", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> getProductDetail(HttpServletRequest request, @ModelAttribute VerifyOderNoReqForm params) throws Exception {
        return ResponseEntity.ok(selfcarePortalApiService.getProductDetail(request, params));
    }

    @ApiOperation(value = "/getServiceHistory", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/getServiceHistory", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> getServiceHistory(HttpServletRequest request, @ModelAttribute VerifyOderNoReqForm params) throws Exception {
        return ResponseEntity.ok(selfcarePortalApiService.getServiceHistory(request, params));
    }
    
    @ApiOperation(value = "/getFilterInfo", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/getFilterInfo", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> getFilterInfo(HttpServletRequest request, @ModelAttribute VerifyOderNoReqForm params) throws Exception {
        return ResponseEntity.ok(selfcarePortalApiService.getFilterInfo(request, params));
    }
    
    @ApiOperation(value = "/getUpcomingService", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/getUpcomingService", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> getUpcomingService(HttpServletRequest request, @ModelAttribute VerifyOderNoReqForm params) throws Exception {
        return ResponseEntity.ok(selfcarePortalApiService.getUpcomingService(request, params));
    }
}
