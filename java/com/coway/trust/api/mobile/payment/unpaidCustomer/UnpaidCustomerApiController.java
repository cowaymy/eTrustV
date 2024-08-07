package com.coway.trust.api.mobile.payment.unpaidCustomer;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.payment.payment.service.UnpaidCustomerApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;


/**
 * @ClassName : UnpaidCustomerApiController.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 8.   KR-HAN        First creation
 * </pre>
 */
@Api(value = "UnpaidCustomer Api ", description = "UnpaidCustomer Api")
@RestController(value = "unpaidCustomerApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/unpaidCustomer")
public class UnpaidCustomerApiController {

	private static final Logger LOGGER = LoggerFactory.getLogger(UnpaidCustomerApiController.class);

	@Resource(name = "unpaidCustomerApiService")
	private UnpaidCustomerApiService unpaidCustomerApiService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	 /**
	 * selectUnpaidCustomerList
	 * @Author KR-HAN
	 * @Date 2019. 11. 8.
	 * @param unpaidCustomerForm
	 * @return
	 * @throws Exception
	 */
	@ApiOperation(value = "UnpaidCustomer List", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectUnpaidCustomerList", method = RequestMethod.GET)
	public ResponseEntity<List<UnpaidCustomerDto>>  selectUnpaidCustomerList(@ModelAttribute UnpaidCustomerForm unpaidCustomerForm) throws Exception {

       Map<String, Object> params = unpaidCustomerForm.createMap(unpaidCustomerForm);
       List<EgovMap> selectUnpaidCustomerList = null;

        // 주문 조회
       selectUnpaidCustomerList = unpaidCustomerApiService.selectUnpaidCustomerList(params);

       List<UnpaidCustomerDto> unpaidCustomerList = selectUnpaidCustomerList.stream().map(r -> UnpaidCustomerDto.create(r)).collect(Collectors.toList());

       return ResponseEntity.ok(unpaidCustomerList);
	}

	 /**
	 * selectUnpaidCustomerDetailList
	 * @Author KR-HAN
	 * @Date 2019. 11. 8.
	 * @param unpaidCustomerForm
	 * @return
	 * @throws Exception
	 */
	@ApiOperation(value = "select Unpaid Customer Detail", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectUnpaidCustomerDetailList", method = RequestMethod.GET)
	public ResponseEntity<List<UnpaidCustomerDto>>  selectUnpaidCustomerDetailList(@ModelAttribute UnpaidCustomerForm unpaidCustomerForm) throws Exception {

       Map<String, Object> params = unpaidCustomerForm.createMap(unpaidCustomerForm);
       List<EgovMap> selectUnpaidCustomerDetailList = null;

       selectUnpaidCustomerDetailList = unpaidCustomerApiService.selectUnpaidCustomerDetailList(params);

       List<UnpaidCustomerDto> unpaidCustomerDetailList = selectUnpaidCustomerDetailList.stream().map(r -> UnpaidCustomerDto.create(r)).collect(Collectors.toList());

       return ResponseEntity.ok(unpaidCustomerDetailList);
	}

}
