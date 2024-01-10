package com.coway.trust.biz.eAccounting.ePR;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.function.Predicate;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("ePRService")
public class ePRServiceImpl implements ePRService {

	@Resource(name = "ePRMapper")
	private ePRMapper ePRMapper;

	@Override
	public EgovMap selectUserCostCenter(Map<String, Object> p) {
		return ePRMapper.selectUserCostCenter(p);
	}

	@Override
	public int selectRequestId() {
		return ePRMapper.selectRequestId();
	}

	@Override
	public int insertRequestDraft(Map<String, Object> p) {
		if (p.get("requestId") == null) {
			int id = this.selectRequestId();
			p.put("id", id);
			return ePRMapper.insertRequestDraft(p);
		} else {
			p.put("id", p.get("requestId"));
			return ePRMapper.updateRequestDraft(p);
		}
	}

	@Override
	public int updateRequest(Map<String, Object> p) {
		return ePRMapper.updateRequest(p);
	}

	@Override
	public int ePRApproval(Map<String, Object> p) {
		List<Integer> results = new ArrayList();
		results.add(ePRMapper.ePRApproval(p));
		EgovMap currentApprv = ePRMapper.getCurrApprv(p);
		if (currentApprv == null) {
			results.add(ePRMapper.updateRequestFinal(p));
		} else if (ePRMapper.getSPCMembers().stream().filter(spcMem -> spcMem.get("memId").toString().equals(currentApprv.get("memId"))).count() > 0) {
			results.add(ePRMapper.updateRequestSPC(p));
		}
		return results.stream().allMatch((i) -> i > 0) ? 1 : 0;
	}

	@Override
	public int deleteDeliverDet(Map<String, Object> p) {
		return ePRMapper.deleteDeliverDet(p);
	}

	@Override
	public int insertDeliverDet(Map<String, Object> p) {
		return ePRMapper.insertDeliverDet(p);
	}

	@Override
	public int insertEditHistory(Map<String, Object> p) {
		EgovMap hist = ePRMapper.currAF(p);
		p.put("a", hist.get("a"));
		p.put("f", hist.get("f"));
		int res = ePRMapper.insertEditHist(p);
		if (p.get("type").equals("1")) {
			ePRMapper.updateRciv(p);
		} else {
			ePRMapper.updateAssign(p);
		}
		return res;
	}

	@Override
	public int insertRequestItems(Map<String, Object> p) {
		return ePRMapper.insertRequestItems(p);
	}

	@Override
	public int insertApprovalLine(Map<String, Object> p) {
		return ePRMapper.insertApprovalLine(p);
	}

	@Override
	public void deleteRequest(Map <String, Object> p) {
		ePRMapper.deleteRequest(p);
	}

	@Override
	public void deleteRequestItems(Map<String, Object> p) {
		ePRMapper.deleteRequestItems(p);
	}

	@Override
	public List<EgovMap> selectRequests(Map<String, Object> p) {
		return ePRMapper.selectRequests(p);
	}

	@Override
	public EgovMap selectRequest(Map<String, Object> p) {
		EgovMap res = ePRMapper.selectRequest(p);
		res.put("deliveryDetails", ePRMapper.selectDeliveryInfo(p));
		return res;
	}

	@Override
	public int cancelEPR(Map<String, Object> p) {
		ePRMapper.insertEditHist(p);
		return ePRMapper.cancelEPR(p);
	}

	@Override
	public EgovMap getFinalApprv() {
		return ePRMapper.getFinalApprv();
	}

	@Override
	public EgovMap getCurrApprv(Map<String, Object> p) {
		return ePRMapper.getCurrApprv(p);
	}

	@Override
	public List<EgovMap> getSPCMembers() {
		return ePRMapper.getSPCMembers();
	}

	@Override
	public String getMemberEmail(Map<String, Object> p) {
		return ePRMapper.getMemberEmail(p);
	}
}