package com.coway.trust.biz.homecare.services.install.impl;


import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.homecare.services.install.HcInstallationReversalService;
import com.coway.trust.biz.services.installation.InstallationReversalService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.crystaldecisions.reports.common.NumberUtil;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("hcInstallationReversalService")
public class HcInstallationReversalServiceImpl extends EgovAbstractServiceImpl implements HcInstallationReversalService{
	private static final Logger logger = LoggerFactory.getLogger(HcInstallationReversalServiceImpl.class);

	@Resource(name = "hcInstallationReversalMapper")
	private HcInstallationReversalMapper hcInstallationReversalMapper;

	@Resource(name = "installationReversalService")
	private InstallationReversalService installationReversalService;

	@Override
	public List<EgovMap> selectReverseReason() throws Exception{
		return hcInstallationReversalMapper.selectReverseReason();
	}

	@Override
	public List<EgovMap> selectFailReason() throws Exception{
		return hcInstallationReversalMapper.selectFailReason();
	}

	@Override
	public List<EgovMap> selectOrderList(Map<String, Object> params) throws Exception{
		return hcInstallationReversalMapper.selectOrderList(params);
	}

	@Override
	public EgovMap selectOrderListDetail1(Map<String, Object> params) throws Exception{
		return hcInstallationReversalMapper.selectOrderListDetail1(params);
	}

	@Override
	public void multiResaval(Map<String, Object> params, SessionVO sessionVO) throws Exception{

		installationReversalService.saveResavalSerial(params);

		int bndlCount = Integer.parseInt((String)params.get("bndlCount"));
		if(bndlCount > 0){
			String instalStrlDate = CommonUtils.nvl(params.get("instalStrlDate").toString());
			String nextCallStrlDate = CommonUtils.nvl(params.get("nextCallStrlDate").toString());
			String failReason = params.get("failReason").toString();
			String reverseReason = params.get("reverseReason").toString();
			String reverseReasonText = params.get("reverseReasonText").toString();

			Map<String, Object> sOrder = null;
			List<EgovMap> bndlList = hcInstallationReversalMapper.selectBndlInfoList(params);
			for (EgovMap sMap : bndlList) {

				EgovMap  list1 = hcInstallationReversalMapper.selectOrderListDetail1(sMap);
				EgovMap  list5 = installationReversalService.installationReversalSearchDetail5(params);

				sOrder = new HashMap<String, Object>();
				sOrder.put("instalStrlDate", instalStrlDate);
				sOrder.put("nextCallStrlDate", nextCallStrlDate);
				sOrder.put("failReason", failReason);
				sOrder.put("reverseReason", reverseReason);
				sOrder.put("reverseReasonText", reverseReasonText);
				sOrder.put("applicationTypeID", list1.get("codeId"));
				sOrder.put("callTypeId", list1.get("codeid1"));
				sOrder.put("ectid", list1.get("c6"));
				sOrder.put("eCustomerName", list1.get("name"));
				sOrder.put("einstallEntryId", sMap.get("installEntryId"));
				sOrder.put("einstallEntryNo", sMap.get("installEntryNo"));
				sOrder.put("eProductID", list1.get("installStkId"));
				sOrder.put("esalesDt", list1.get("salesDt"));
				sOrder.put("esalesOrdId", sMap.get("salesOrdId"));
				sOrder.put("esalesOrdNo", sMap.get("salesOrdNo"));
				sOrder.put("retWarehouseID", "");
				sOrder.put("hidInstallEntryNo", list1.get("installEntryNo"));
				sOrder.put("hidSalesOrderId", sMap.get("salesOrdId"));
				sOrder.put("hidSerialNo", list1.get("serialNo"));
				sOrder.put("hidSerialRequireChkYn", "N");		// no serial check
				sOrder.put("userId", sessionVO.getUserId());

				if(list5 != null && list5.get("whLocId") != null && (int)list5.get("whLocId") != 0 ){
					sOrder.put("inChargeCTWHID", list5.get("whLocId"));
				}else{
					sOrder.put("inChargeCTWHID", 0);
				}

				installationReversalService.saveResavalSerial(sOrder);
			}
		}
	}

}
