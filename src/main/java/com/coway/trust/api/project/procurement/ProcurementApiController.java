package com.coway.trust.api.project.procurement;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.api.ProcurementApiService;
import com.coway.trust.biz.api.vo.procurement.CostCenterReqForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

@Api(value = "ProcurementApiController", description = "ProcurementApiController")
@RestController(value = "ProcurementApiController")
@RequestMapping(AppConstants.WEB_API_BASE_URI + "/procurement")
public class ProcurementApiController {
	private static final Logger LOGGER = LoggerFactory.getLogger(ProcurementApiController.class);

    @Resource(name="procurementApiService")
    private ProcurementApiService procurementApiService;

    @ApiOperation(value = "/getCostCtrGLaccBudgetCdInfo", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/getCostCtrGLaccBudgetCdInfo", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> getCostCtrGLaccBudgetCdInfo(HttpServletRequest request, @ModelAttribute CostCenterReqForm params) throws Exception {
        return ResponseEntity.ok(procurementApiService.getCostCtrGLaccBudgetCdInfo(request, params));
    }
    
    @ApiOperation(value = "/getVendorPaymentRecord", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/getVendorPaymentRecord", method = RequestMethod.GET)
    public ResponseEntity<EgovMap> getVendorPaymentRecord(HttpServletRequest request) throws Exception {
        return ResponseEntity.ok(procurementApiService.getVendorPaymentRecord(request));
    }
}
