package com.coway.trust.biz.api;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.coway.trust.biz.api.vo.chatbotCallLog.CallLogAppointmentReqForm;
import com.coway.trust.biz.api.vo.chatbotCallLog.CallLogAppointmentRespDto;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ChatbotCallLogApiService {
	CallLogAppointmentRespDto reconfirmCustomerDetail(CallLogAppointmentReqForm params, HttpServletRequest request)
			throws Exception;

	CallLogAppointmentRespDto confirmAppointment(CallLogAppointmentReqForm params, HttpServletRequest request)
			throws Exception;

	CallLogAppointmentRespDto getAppointmentDateDetail(CallLogAppointmentReqForm params, HttpServletRequest request)
			throws Exception;
}
