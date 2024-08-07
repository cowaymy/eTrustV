/**
 * @author Adrian C.
 **/
package com.coway.trust.web.logistics.bookingstatus;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.logistics.bookingstatus.BookingStatusService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.config.handler.SessionHandler;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Controller
@RequestMapping(value = "/logistics/BookingStatus")
public class BookingStatusController {

	private static final Logger logger = LoggerFactory.getLogger(BookingStatusController.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "commonService")
	private CommonService commonService;

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Autowired
	private SessionHandler sessionHandler;

	@Resource(name = "BookingStatusService")
	private BookingStatusService bookingStatusService;

	@RequestMapping(value = "/bookingStatusList.do")
	public String BookingStatus(@RequestParam Map<String, Object> params)
	{
		return "logistics/BookingStatus/bookingStatusList";
	}

	@RequestMapping(value = "/searchBookingStatusList.do", method = RequestMethod.POST)
	public ResponseEntity<ReturnMessage> searchBookingStatusList(@RequestBody Map<String, Object> params, Model model, SessionVO sessionVO)
    throws Exception
	{

		List<EgovMap> list = bookingStatusService.searchBookingStatusList(params);

		ReturnMessage message = new ReturnMessage();

		message.setCode(AppConstants.SUCCESS);
		message.setMessage(messageAccessor.getMessage(AppConstants.MSG_SUCCESS));
		message.setDataList(list);

		return ResponseEntity.ok(message);
	}
}
