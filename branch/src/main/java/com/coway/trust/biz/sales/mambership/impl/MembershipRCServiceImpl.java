/**
 *
 */
package com.coway.trust.biz.sales.mambership.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.mambership.MembershipRCService;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author kmo
 *
 */
@Service("membershipRCService")
public class MembershipRCServiceImpl extends EgovAbstractServiceImpl implements MembershipRCService {

	private static Logger logger = LoggerFactory.getLogger(MembershipRCServiceImpl.class);

	@Resource(name = "membershipRCMapper")
	private MembershipRCMapper membershipRCMapper;


	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Override
	public List<EgovMap> selectCancellationList(Map<String, Object> params) {
		return membershipRCMapper.selectCancellationList(params);
	}
	@Override
	public List<EgovMap> selectBranchList(Map<String, Object> params) {
		return membershipRCMapper.selectBranchList(params);
	}
	@Override
	public List<EgovMap> selectReasonList(Map<String, Object> params) {
		return membershipRCMapper.selectReasonList(params);
	}
	@Override
	public EgovMap selectCancellationInfo(Map<String, Object> params) {
		return membershipRCMapper.selectCancellationInfo(params);
	}
	@Override
	public List<EgovMap> selectCodeList(Map<String, Object> params) {
		//
		return membershipRCMapper.selectCodeList(params);
	}
	@Override
	public List<EgovMap> selectCancellReqInfo(Map<String, Object> params) {
		return membershipRCMapper.selectCancellReqInfo(params);
	}

	@Override
	public EgovMap selectMemInfo(Map<String, Object> params) {

		int currentSchedule = 0;
        int billSchedule = 0;
        int unbillMth = 0;
        float unbillAmt = 0;
        float monthlyFee = 0;

		EgovMap memInfo = membershipRCMapper.selectCancellMemInfo(params);

		billSchedule = membershipRCMapper.selectBillInfo(params);

		EgovMap schedulesInfo = membershipRCMapper.selectContractSchedules(params);

		if(!CommonUtils.isEmpty(schedulesInfo) ){
			currentSchedule = Integer.parseInt(schedulesInfo.get("srvPaySchdulNo").toString());
			monthlyFee = Float.parseFloat(schedulesInfo.get("srvPaySchdulAmt").toString());

		}

		if (currentSchedule > 0)
        {
            unbillMth = currentSchedule - billSchedule;
            if (unbillMth > 0)
                unbillAmt = monthlyFee * unbillMth;
        }


		float ledgerAmt = membershipRCMapper.selectContractLedger(params);
		if(ledgerAmt < 0 ){
			ledgerAmt = 0;
		}

		memInfo.put("unbillAmt", unbillAmt);
		memInfo.put("outstandingAmount", ledgerAmt);
		memInfo.put("scheduleNo", currentSchedule);
		memInfo.put("monthlyFee", monthlyFee);


    	//int TotalMthUse = currentSchedule;
        int ObPeriod = 12;
        float RentalFees = Float.parseFloat(memInfo.get("srvCntrctRental").toString());
        float CurrentOutstanding =  Float.parseFloat(memInfo.get("outstandingAmount").toString());
        float PenaltyAmt = 0;

        if (currentSchedule != 0 && currentSchedule < ObPeriod)
        {
            PenaltyAmt = ((RentalFees * (ObPeriod - currentSchedule)) / 2);
        }

        memInfo.put("obPeriod", ObPeriod);
        memInfo.put("penaltyCharge", PenaltyAmt);
        memInfo.put("totalAmt" , CurrentOutstanding + PenaltyAmt);

		return memInfo;
	}

	@Override
	public EgovMap selectOrdInfo(Map<String, Object> params) {
		return membershipRCMapper.selectOrdInfo(params);
	}
	@Override
	public EgovMap selectCustInfo(Map<String, Object> params) {

		EgovMap SrvMemConfigInfo = membershipRCMapper.selectSrvMemConfigInfo(params);

		EgovMap addrInfo = membershipRCMapper.selectMemAddrInfo(params);

		EgovMap custInfo = membershipRCMapper.selectCustInfo(params);

		EgovMap contactInfo = membershipRCMapper.selectCustContactInfo(params);


		custInfo.put("custName", custInfo.get("name"));
		custInfo.put("custNric", custInfo.get("nric"));

		custInfo.put("srvPrdExprDt", SrvMemConfigInfo.get("srvPrdExprDt"));
		custInfo.put("pacDesc", SrvMemConfigInfo.get("pacDesc"));

		custInfo.put("instAddrDtl", addrInfo.get("nstAddrDtl"));
		custInfo.put("instStreet", addrInfo.get("instStreet"));
		custInfo.put("instCity", addrInfo.get("instCity"));
		custInfo.put("instArea", addrInfo.get("instArea"));
		custInfo.put("instCountry", addrInfo.get("instCountry"));
		custInfo.put("instPostcode", addrInfo.get("instPostcode"));

		custInfo.put("contName", contactInfo.get("name"));
		custInfo.put("telM1", contactInfo.get("telM1"));
		custInfo.put("telO", contactInfo.get("telO"));
		custInfo.put("telR", contactInfo.get("telR"));

		return custInfo;
	}

	@Override
	public  String saveContractCancellation(Map<String, Object> params) {

		params.put("docNoId", 146);
		String docNo = membershipRCMapper.getDocNo(params);
		params.put("docNo", docNo);

		String msg = messageAccessor.getMessage(SalesConstants.MSG_RENTAL_REM);
		params.put("msg", msg);

		membershipRCMapper.insert_SAL0086D(params);

		EgovMap contactInfo = membershipRCMapper.selectServiceContracts(params);

		if(!CommonUtils.isEmpty(contactInfo)){
			membershipRCMapper.update_SAL0077D(params);
		}

		EgovMap periodInfo = membershipRCMapper.selectSrvConfigPeriods(params);

		if(!CommonUtils.isEmpty(periodInfo)){
			params.put("srvPrdId", periodInfo.get("srvPrdId"));
			membershipRCMapper.update_SAL0088D(params);
		}

		EgovMap contractDetailInfo = membershipRCMapper.selectServiceContractDetail(params);

		if(!CommonUtils.isEmpty(contractDetailInfo)){
			params.put("stus", "TER");
			membershipRCMapper.update_SAL0078D(params);
		}

		membershipRCMapper.saveCanclPnaltyBill(params);

		return docNo;
	}

	@Override
	public EgovMap selectSrvMemConfigInfo(Map<String, Object> params) {
		return membershipRCMapper.selectSrvMemConfigInfo(params);
	}
}
