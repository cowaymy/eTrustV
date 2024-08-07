package com.coway.trust.api.mobile.sales.salesDashboardApi;

import javax.annotation.Resource;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.salesDashboardApi.SalesDashboardApiService;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;


/**
 * @ClassName : SalesDashboardApiController.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 12. 23.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Api(value = "SalesDashboardApiController", description = "SalesDashboardApiController")
@RestController(value = "SalesDashboardApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/salesDashboardApi")
public class SalesDashboardApiController {
	@Resource(name = "SalesDashboardApiService")
	private SalesDashboardApiService salesDashboardApiService;



	@ApiOperation(value = "selectSalesDashboard", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectSalesDashboard", method = RequestMethod.GET)
	public ResponseEntity<SalesDashboardApiDto> selectSalesDashboard(@ModelAttribute SalesDashboardApiForm param) throws Exception {
		return ResponseEntity.ok(salesDashboardApiService.selectSalesDashboard(param));
	}
}
