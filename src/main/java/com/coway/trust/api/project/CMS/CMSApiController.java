package com.coway.trust.api.project.CMS;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.api.CMSApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

@Api(value = "CMSApiController", description = "CMSApiController")
@RestController(value = "CMSApiController")
@RequestMapping(AppConstants.WEB_API_BASE_URI + "/CMS")
public class CMSApiController {

    @Resource(name = "CMSApiService")
    private CMSApiService cmsApiService;

    @ApiOperation(value = "/genCsvFile", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/genCsvFile", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> genCsvFile(HttpServletRequest request, @RequestParam Map<String, Object> params) throws Exception {
        return ResponseEntity.ok(cmsApiService.genCsvFile(request, params));
    }
}
