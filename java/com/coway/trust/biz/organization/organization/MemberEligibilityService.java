package com.coway.trust.biz.organization.organization;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.organization.organization.vo.MemberListVO;
import com.coway.trust.biz.sales.order.vo.DocSubmissionVO;
import com.coway.trust.biz.sales.order.vo.OrderVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface MemberEligibilityService {

	List<EgovMap> selectMemberEligibility(Map<String, Object> params);

	void submitMemberRejoin(Map<String, Object> params);

	boolean sendEmail(Map<String, Object> params);

	EgovMap memberRejoinCheck(Map<String, Object> params);
}
