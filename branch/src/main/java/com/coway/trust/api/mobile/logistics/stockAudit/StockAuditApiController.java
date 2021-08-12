package com.coway.trust.api.mobile.logistics.stockAudit;

import java.util.List;
import java.util.Map;
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
import com.coway.trust.biz.logistics.stockAudit.StockAuditApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

/**
 * @ClassName : StockAuditApiController.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 10. 28.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Api(value = "StockAuditApiController", description = "StockAuditApiController")
@RestController(value = "StockAuditApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/stockAuditApi")
public class StockAuditApiController {



	private static final Logger LOGGER = LoggerFactory.getLogger(StockAuditApiController.class);



	@Resource(name = "StockAuditApiService")
	private StockAuditApiService stockAuditApiService;



    @ApiOperation(value = "selectStockAuditList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/selectStockAuditList", method = RequestMethod.GET)
    public ResponseEntity<List<StockAuditApiDto>> selectStockAuditList(@ModelAttribute StockAuditApiFormDto param) throws Exception {
        List<EgovMap>  selectStockAuditList = stockAuditApiService.selectStockAuditList( param );
        if(LOGGER.isErrorEnabled()){
            for (int i = 0; i < selectStockAuditList.size(); i++) {
                    LOGGER.debug("selectStockAuditDetailList    값 : {}", selectStockAuditList.get(i));
            }
        }
        return ResponseEntity.ok(selectStockAuditList.stream().map(r -> StockAuditApiDto.create(r)).collect(Collectors.toList()));
    }



    @ApiOperation(value = "selectStockAuditDetail", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/selectStockAuditDetail", method = RequestMethod.GET)
    public ResponseEntity<StockAuditApiDto> selectStockAuditDetail(@ModelAttribute StockAuditApiFormDto param) throws Exception {
        EgovMap selectStockAuditDetail = stockAuditApiService.selectStockAuditDetail(param);
        return ResponseEntity.ok(StockAuditApiDto.create(selectStockAuditDetail));
    }



    @ApiOperation(value = "selectStockAuditDetailList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/selectStockAuditDetailList", method = RequestMethod.GET)
    public ResponseEntity<Map<String, Object>> selectStockAuditDetailList(@ModelAttribute StockAuditApiFormDto param) throws Exception {
        return ResponseEntity.ok(stockAuditApiService.selectStockAuditDetailList(param));
    }



    @ApiOperation(value = "saveStockAudit", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/saveStockAudit", method = RequestMethod.POST)
    public ResponseEntity<List<StockAuditApiDto>> saveStockAudit(@RequestBody List<StockAuditApiDto> param) throws Exception {
        return ResponseEntity.ok(stockAuditApiService.saveStockAudit(param));
    }



    @ApiOperation(value = "saveRequestApprovalStockAudit", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    @RequestMapping(value = "/saveRequestApprovalStockAudit", method = RequestMethod.POST)
    public ResponseEntity<List<StockAuditApiDto>> saveRequestApprovalStockAudit(@RequestBody List<StockAuditApiDto> param) throws Exception {
        return ResponseEntity.ok(stockAuditApiService.saveRequestApprovalStockAudit(param));
    }
}