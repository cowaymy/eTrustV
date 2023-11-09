package com.coway.trust.biz.logistics.agreement.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.agreement.agreementService;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("agreementService")

public class agreementServImpl extends EgovAbstractServiceImpl implements agreementService {

    @Resource(name = "agreementMapper")
    private agreementMapper agreementMapper;

    @Override
    public EgovMap prevAgreement(Map<String, Object> params) {
        return agreementMapper.prevAgreement(params);
    }

    @Override
    public EgovMap getMemHPpayment(Map<String, Object> params) {
        return agreementMapper.getMemHPpayment(params);
    }


    @Override
    public List<EgovMap> memberList(Map<String, Object> params) {
        return agreementMapper.memberList(params);
    }

    @Override
    public List<EgovMap> getMemStatus(Map<String, Object> params) {
        return agreementMapper.getMemStatus(params);
    }

    @Override
    public List<EgovMap> getMemLevel(Map<String, Object> params) {
        return agreementMapper.getMemLevel(params);
    }

    @Override
    public List<EgovMap> getAgreementVersion(Map<String, Object> params) {
        return agreementMapper.getAgreementVersion(params);
    }

    @Override
    public EgovMap getBranchCd(Map<String, Object> params) {
        return agreementMapper.getBranchCd(params);
    }

	@Override
	public List<EgovMap> branch() {
		return agreementMapper.branch();
	}

	@Override
    public EgovMap cdEagmt1(Map<String, Object> params) {
        return agreementMapper.cdEagmt1(params);
    }

	@Override
	public int checkConsent(Map<String, Object> params) {
	    return agreementMapper.checkConsent(params);
	}

	@Override
    public List<EgovMap> consentList(Map<String, Object> params) {
        return agreementMapper.consentList(params);
    }

	@Override
    public List<EgovMap> selectAgreementHistoryList(Map<String, Object> params) {
        return agreementMapper.selectAgreementHistoryList(params);
    }

	@Override
	public ReturnMessage agreementNamelistUpload(List<Map<String, Object>> params,
			SessionVO sessionVO) {
		ReturnMessage message = new ReturnMessage();
		int userId = sessionVO.getUserId();

		for(int i = 0; i < params.size(); i++) {
			Map<String, Object> item = (Map<String, Object>) params.get(i);
			int result = agreementMapper.isMemberExist(item);

			if(result == 0){
				message.setMessage("Unable to find member code : " + item.get("memCode").toString());
				message.setCode(AppConstants.FAIL);
				return message;
			}
		}

		for(int i = 0; i < params.size(); i++) {
			Map<String, Object> item = (Map<String, Object>) params.get(i);
			int aplicntIdSeq = agreementMapper.selectNextAplctnIdSeq();
			int currentRoleId = agreementMapper.selectCurrentUserRole(item);

			//INSERT AFTER APLICNT_ID GET
			item.put("userId", userId);
			item.put("aplctnId", aplicntIdSeq);
			item.put("roleId", currentRoleId);
			agreementMapper.insertUploadNamelist(item);
			agreementMapper.insertNewAgreementPop(item);
			agreementMapper.updateMemberAgreementAplictnId(item);
		}

		message.setMessage("Upload Success!");
		message.setCode(AppConstants.SUCCESS);
		return message;
	}
}
