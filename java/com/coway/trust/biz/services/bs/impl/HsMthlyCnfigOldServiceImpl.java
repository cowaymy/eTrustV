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
import com.coway.trust.biz.services.bs.HsMthlyCnfigOldService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.organization.organization.MemberEventListController;
import com.coway.trust.web.sales.SalesConstants;
import com.ibm.icu.util.StringTokenizer;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("hsMthlyCnfigOldService")
public class HsMthlyCnfigOldServiceImpl extends EgovAbstractServiceImpl implements HsMthlyCnfigOldService {

	private static final Logger logger = LoggerFactory.getLogger(MemberEventListController.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "hsMthlyCnfigOldMapper")
	private HsMthlyCnfigOldMapper hsMthlyCnfigOldMapper;

	@Resource(name = "hsManualOldMapper")
	private HsManualOldMapper hsManualOldMapper;

	@Resource(name = "hsManualMapper")
	private HsManualMapper hsManualMapper;

	@Override
	public List<EgovMap> selectHsMnthlyMaintainOldList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsMthlyCnfigOldMapper.selectHsMnthlyMaintainOldList(params);
	}

	@Override
	public EgovMap selectBSSettingOld(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return hsMthlyCnfigOldMapper.selectBSSettingOld(params);
	}

	@Override
	public EgovMap selectHsMnthlyMaintainOldDetail(Map<String, Object> params) {

		EgovMap hsOldDetail = new EgovMap();
		//Basic Info
		EgovMap orderInstallationInfo        = hsManualOldMapper.selectOrderInstallationInfoByOrdID(params);
		EgovMap bsSetting          = hsMthlyCnfigOldMapper.selectBSSettingOld(params);

		hsOldDetail.put("orderInstallationInfo",     	orderInstallationInfo);
		hsOldDetail.put("bsSetting",       	bsSetting);

		return hsOldDetail;
	};

	@Override
	public String selectHSCodyByCode(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return (String)hsMthlyCnfigOldMapper.selectHSCodyByCode(params);
	}

	@Override
	public int updateCurrentMonthSettingCody(Map<String, Object> params) {
		int cnt = 0;
		LinkedHashMap  bsSetting = (LinkedHashMap)  params.get("hsResultM");
		if (bsSetting.size() > 0) {
			hsManualMapper.updateAssignCody(params);
			cnt = 1;
		}
		return cnt;
	}

}
