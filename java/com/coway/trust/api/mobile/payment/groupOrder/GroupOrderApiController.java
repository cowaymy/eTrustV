package com.coway.trust.api.mobile.payment.groupOrder;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.groupOrder.service.GroupOrderApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;

/**
 * @ClassName : GroupOrderApiController.java
 * @Description : GroupOrder Api Controller
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 9. 19.   KR-HAN        First creation
 * </pre>
 */
@Api(value = "groupOrder api", description = "groupOrder api")
@RestController(value = "groupOrderApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/groupOrder")
public class GroupOrderApiController {

	private static final Logger LOGGER = LoggerFactory.getLogger(GroupOrderApiController.class);

	@Resource(name = "groupOrderApiService")
	private GroupOrderApiService groupOrderApiService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	 /**
	 * Group Order 조회
	 * @Author KR-HAN
	 * @Date 2019. 9. 19.
	 * @param groupOrderForm
	 * @return
	 * @throws Exception
	 */
	@ApiOperation(value = "GroupOrder", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectGroupOrder", method = RequestMethod.GET)
	public ResponseEntity<List<GroupOrderDto>>  selectGroupOrder(@ModelAttribute GroupOrderForm groupOrderForm) throws Exception {

        Map<String, Object> params = groupOrderForm.createMap(groupOrderForm);
        List<EgovMap> selectGroupOrder = null;

         // 즈믄 조회
        selectGroupOrder = groupOrderApiService.selectGroupOrder(params);

        List<GroupOrderDto> groupOrder = selectGroupOrder.stream().map(r -> GroupOrderDto.create(r)).collect(Collectors.toList());

        return ResponseEntity.ok(groupOrder);
	}


	 /**
	 * Group Order 목록 조회
	 * @Author KR-HAN
	 * @Date 2019. 9. 24.
	 * @param groupOrderForm
	 * @return
	 * @throws Exception
	 */
	@ApiOperation(value = "GroupOrder List", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectGroupOrderList", method = RequestMethod.GET)
	public ResponseEntity<List<GroupOrderDto>>  selectGroupOrderList(@ModelAttribute GroupOrderForm groupOrderForm) throws Exception {

        Map<String, Object> params = groupOrderForm.createMap(groupOrderForm);
        List<EgovMap> selectGroupOrderList = null;

        // 주문 리스트 조회
        selectGroupOrderList = groupOrderApiService.selectGroupOrderList(params);

        List<GroupOrderDto> groupOrderList = selectGroupOrderList.stream().map(r -> GroupOrderDto.create(r)).collect(Collectors.toList());

        return ResponseEntity.ok(groupOrderList);
	}

	 /**
	 * Group Order 상세 조회
	 * @Author KR-HAN
	 * @Date 2019. 9. 25.
	 * @param groupOrderForm
	 * @return
	 * @throws Exception
	 */
	@ApiOperation(value = "GroupOrder Detail List", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectGroupOrderDetailList", method = RequestMethod.GET)
	public ResponseEntity<List<GroupOrderDto>>  selectGroupOrderDetailList(@ModelAttribute GroupOrderForm groupOrderForm) throws Exception {

        Map<String, Object> params = groupOrderForm.createMap(groupOrderForm);
        List<EgovMap> selectGroupOrderDetailList = null;

        // 주문 리스트 조회
        selectGroupOrderDetailList = groupOrderApiService.selectGroupOrderDetailList(params);

        List<GroupOrderDto> groupOrderDetailList = selectGroupOrderDetailList.stream().map(r -> GroupOrderDto.create(r)).collect(Collectors.toList());

        return ResponseEntity.ok(groupOrderDetailList);
	}


	 /**
	 * saveGroupOrderMove
	 * @Author KR-HAN
	 * @Date 2019. 9. 27.
	 * @param groupOrderForm
	 * @throws Exception
	 */
	@ApiOperation(value = "Save Group Order Move", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public void saveGroupOrderMove(@RequestBody GroupOrderForm  groupOrderForm) throws Exception {
		groupOrderApiService.saveGroupOrderMove(groupOrderForm);
	}

	 /**
	 * TO-DO Description
	 * @Author KR-HAN
	 * @Date 2019. 11. 11.
	 * @param groupOrderForm
	 * @throws Exception
	 */
	@ApiOperation(value = "Save Group Order Cancel", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/saveGroupOrderCancel", method = RequestMethod.POST)
	public void saveGroupOrderCancel(@RequestBody GroupOrderForm  groupOrderForm) throws Exception {
		groupOrderApiService.saveGroupOrderCancel(groupOrderForm);
	}


}
