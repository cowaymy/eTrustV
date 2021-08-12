package com.coway.trust.api.mobile.payment.mobileTicket;

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
import com.coway.trust.biz.payment.payment.service.MobileTicketApiService;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;



/**
 * @ClassName : MobileTicketApiController.java
 * @Description : MobileTicketApiController
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 12.   KR-HAN        First creation
 * </pre>
 */
@Api(value = "MobileTicket Api ", description = "MobileTicket Api")
@RestController(value = "mobileTicketApiController")
@RequestMapping(AppConstants.MOBILE_API_BASE_URI + "/mobileTicket")
public class MobileTicketApiController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MobileTicketApiController.class);

	@Resource(name = "mobileTicketApiService")
	private MobileTicketApiService mobileTicketApiService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	 /**
	 * selectMobileTicketList
	 * @Author KR-HAN
	 * @Date 2019. 11. 12.
	 * @param mobileTicketForm
	 * @return
	 * @throws Exception
	 */
	@ApiOperation(value = "MobileTicket List", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectMobileTicketList", method = RequestMethod.GET)
	public ResponseEntity<List<MobileTicketDto>>  selectMobileTicketList(@ModelAttribute MobileTicketForm mobileTicketForm) throws Exception {
       Map<String, Object> params = mobileTicketForm.createMap(mobileTicketForm);
       List<EgovMap> selectMobileTicketList = null;

       selectMobileTicketList = mobileTicketApiService.selectMobileTicketList(params);

       List<MobileTicketDto> mobileTicketList = selectMobileTicketList.stream().map(r -> MobileTicketDto.create(r)).collect(Collectors.toList());

       return ResponseEntity.ok(mobileTicketList);
	}

	 /**
	 * saveMobileTicketCancel
	 * @Author KR-HAN
	 * @Date 2019. 11. 12.
	 * @param mobileTicketForm
	 * @throws Exception
	 */
	@ApiOperation(value = "Save Mobile Ticket Cancel", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/saveMobileTicketCancel", method = RequestMethod.POST)
	public void saveMobileTicketCancel(@RequestBody MobileTicketForm  mobileTicketForm) throws Exception {
		mobileTicketApiService.saveMobileTicketCancel(mobileTicketForm);
	}


	 /**
	 * selectMobileTicketDetail
	 * @Author KR-HAN
	 * @Date 2019. 11. 12.
	 * @param mobileTicketForm
	 * @return
	 * @throws Exception
	 */
	@ApiOperation(value = "select Mobile Ticket Detail", consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
	@RequestMapping(value = "/selectMobileTicketDetailPost", method = RequestMethod.GET)
	public ResponseEntity<MobileTicketDto>  selectMobileTicketDetail(@ModelAttribute MobileTicketForm mobileTicketForm) throws Exception {

       Map<String, Object> params = MobileTicketForm.createMap(mobileTicketForm);
       EgovMap resultMap = null;

        //
       resultMap = mobileTicketApiService.selectMobileTicketDetail(params);

       return ResponseEntity.ok(MobileTicketDto.create(resultMap));
	}

}
