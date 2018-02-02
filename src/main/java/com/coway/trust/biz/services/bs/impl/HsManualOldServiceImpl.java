package com.coway.trust.biz.services.bs.impl;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.logistics.returnusedparts.ReturnUsedPartsService;
import com.coway.trust.biz.sales.ccp.impl.CcpAgreementMapper;
import com.coway.trust.biz.services.as.impl.ServicesLogisticsPFCMapper;
import com.coway.trust.biz.services.bs.HsManualOldService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.organization.organization.MemberEventListController;
import com.coway.trust.web.sales.SalesConstants;
import com.ibm.icu.util.StringTokenizer;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("hsManualOldService")
public class HsManualOldServiceImpl extends EgovAbstractServiceImpl implements HsManualOldService {

	private static final Logger logger = LoggerFactory.getLogger(MemberEventListController.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "hsManualOldMapper")
	private HsManualOldMapper hsManualOldMapper;

	@Override
	public List<EgovMap> selectHsOldConfigList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualOldMapper.selectHsOldConfigList(params);
	}

	@Override
	public List<EgovMap> selectStateList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualOldMapper.selectStateList(params);
	}

	@Override
	public List<EgovMap> selectAreaList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualOldMapper.selectAreaList(params);
	}

	@Override
	public List<EgovMap> selectHSCodyOldList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualOldMapper.selectHSCodyOldList(params);
	}

	@Override
	public EgovMap selectOrderInstallationInfoByOrdID(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualOldMapper.selectOrderInstallationInfoByOrdID(params);
	}

	@Override
	public EgovMap selectBSOrderServiceSetting(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsManualOldMapper.selectBSOrderServiceSetting(params);
	}

	@Override
	public EgovMap selectHsOldBasicListDetail(Map<String, Object> params) {

		EgovMap hsOldDetail = new EgovMap();

		//Basic Info
		EgovMap orderInstallationInfo        = hsManualOldMapper.selectOrderInstallationInfoByOrdID(params);
		EgovMap bsOrderServiceSetting          = hsManualOldMapper.selectBSOrderServiceSetting(params);

		hsOldDetail.put("orderInstallationInfo",     	orderInstallationInfo);
		hsOldDetail.put("bsOrderServiceSetting",       	bsOrderServiceSetting);

		return hsOldDetail;
	};

}
