package com.coway.trust.biz.organization.organization.impl;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.lang.reflect.Type;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.rmi.RemoteException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.atomic.AtomicInteger;

import javax.annotation.Resource;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.StopWatch;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.AppConstants;
import com.coway.trust.api.callcenter.common.CommonConstants;
import com.coway.trust.api.project.LMS.LMSApiForm;
import com.coway.trust.api.project.LMS.LMSApiRespForm;
import com.coway.trust.api.project.LMS.LMSMemApiForm;
import com.coway.trust.biz.api.CommonApiService;
import com.coway.trust.biz.api.LMSApiService;
import com.coway.trust.biz.application.impl.FileApplicationImpl;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.common.FileGroupVO;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.impl.FileMapper;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.organization.organization.MemberApprovalService;
import com.coway.trust.biz.organization.organization.MemberEligibilityService;
import com.coway.trust.biz.organization.organization.vo.DocSubmissionVO;
import com.coway.trust.biz.organization.organization.vo.MemberListVO;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.organization.organization.MemberListController;
import com.google.gson.Gson;
import com.ibm.icu.util.Calendar;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("memberApprovalService")

public class MemberApprovalServiceImpl extends EgovAbstractServiceImpl implements MemberApprovalService{
	private static final Logger LOGGER = LoggerFactory.getLogger(MemberEligibilityServiceImpl.class);

	@Resource(name = "memberApprovalMapper")
	private MemberApprovalMapper memberApprovalMapper;

	@Override
	public List<EgovMap> selectMemberApproval(Map<String, Object> params) {
		return memberApprovalMapper.selectMemberApproval(params);
	}

	@Override
	public EgovMap selectAttachDownload(Map<String, Object> params) {
		return memberApprovalMapper.selectAttachDownload(params);
	}

	@Override
	public void submitMemberApproval(Map<String, Object> params) {
		memberApprovalMapper.submitMemberApproval(params);
	}
}
