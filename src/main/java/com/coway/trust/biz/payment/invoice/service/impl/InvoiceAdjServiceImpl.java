package com.coway.trust.biz.payment.invoice.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.payment.invoice.service.InvoiceAdjService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("invoiceAdjService")
public class InvoiceAdjServiceImpl extends EgovAbstractServiceImpl implements InvoiceAdjService{

	@Resource(name = "invoiceAdjMapper")
	private InvoiceAdjMapper invoiceMapper;
	
	@Resource(name = "commonMapper")
	private CommonMapper commonMapper;

	@Override
	public List<EgovMap> selectInvoiceAdj(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return invoiceMapper.selectInvoiceAdjList(params);
	}

	@Override
	public List<EgovMap> selectNewAdjMaster(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return invoiceMapper.selectNewAdjMaster(params);
	}

	@Override
	public List<EgovMap> selectNewAdjDetailList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return invoiceMapper.selectNewAdjDetailList(params);
	}
	
	
	/**
	 * Adjustment CN/DN AccID  조회
	 * @param params
	 * @return
	 */
	@Override
	public EgovMap getAdjustmentCnDnAccId(Map<String, Object> params){
		return invoiceMapper.getAdjustmentCnDnAccId(params);
	}
	
	
    /**
	 * Adjustment CN/DN request  등록
	 * @param params
	 * @return
	 */
	@Override
	public String saveNewAdjList(int adjustmentType , Map<String, Object> masterParamMap, List<Object> detailParamList){
		
		int memoAdjustmentId = invoiceMapper.getAdjustmentId();
		String reportNo = commonMapper.selectDocNo("18");
		
		String adjustmentNo = "";		
		if(adjustmentType == 1293){
			adjustmentNo = commonMapper.selectDocNo("134");
		}else{
			adjustmentNo = commonMapper.selectDocNo("135");
		}
		
		//마스터 정보 등록
		masterParamMap.put("memoAdjustId", memoAdjustmentId);
		masterParamMap.put("memoAdjustRefNo", adjustmentNo);
		masterParamMap.put("memoAdjustReportNo", reportNo);
		
		invoiceMapper.saveNewAdjMaster(masterParamMap);
		
		//Detail Data 등로
    	if (detailParamList.size() > 0) {    		
    		HashMap<String, Object> hm = null;    		
    		for (Object map : detailParamList) {
    			hm = (HashMap<String, Object>) map;  
    			
    			hm.put("memoAdjustId", memoAdjustmentId);
    			invoiceMapper.saveNewAdjDetail(hm);    			
    		}
    	}
    	
    	return adjustmentNo + " / " + reportNo;
	}
	
	/**
	 * Adjustment Batch ID 채번
	 * @param params
	 * @return
	 */
	@Override
	public int getAdjBatchId(){
		return invoiceMapper.getAdjBatchId();
	}

}
