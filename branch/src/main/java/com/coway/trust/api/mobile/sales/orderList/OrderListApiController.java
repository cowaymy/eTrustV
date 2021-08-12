package com.coway.trust.api.mobile.sales.orderList;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.orderList.OrderListApiService;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;


/**
 * @ClassName : OrderListApiController.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 12. 23.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Api(value = "OrderListApiController", description = "OrderListApiController")
@RestController(value = "OrderListApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/orderListApi")
public class OrderListApiController {
	@Resource(name = "OrderListApiService")
	private OrderListApiService orderListApiService;



	@ApiOperation(value = "selectOrderList", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectOrderList", method = RequestMethod.GET)
	public ResponseEntity<List<OrderListApiDto>> selectOrderList(@ModelAttribute OrderListApiForm param) throws Exception {
		return ResponseEntity.ok(orderListApiService.selectOrderList(param));
	}
}
