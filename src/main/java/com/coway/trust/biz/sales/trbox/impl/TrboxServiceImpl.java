package com.coway.trust.biz.sales.trbox.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.pos.PosService;
import com.coway.trust.biz.sales.pos.impl.PosMapper;
import com.coway.trust.biz.sales.trbox.TrboxService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("trboxService")
public class TrboxServiceImpl extends EgovAbstractServiceImpl implements TrboxService {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource(name = "trboxMapper")
	private TrboxMapper trboxMapper;

	@Override
	public List<EgovMap> selectTrboxManagementList(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return trboxMapper.selectTrboxManagementList(params);
	}

	@Override
	public List<EgovMap> selectTrboxManageDetailList(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return trboxMapper.selectTrboxManageDetailList(params);
	}

	@Override
	public String postNewTrboxManagementSave(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		Map<String, Object> map = trboxMapper.selectTrboxManageBoxNo("71");
		String trboxno = "";
		int trboxid = 0;
		if (map.isEmpty()){
			trboxno = "";
		}else{
			trboxno = (String)map.get("docfullno");
			//trboxid = ;
			params.put("boxno", trboxno);
			params.put("boxid", (String)map.get("trboxid"));
			trboxMapper.newTrboxManageInsert(params);
			
			params.put("trrecordid" , (String)map.get("trrcordid"));
			trboxMapper.newTrboxRecordCardInsert(params);
			
			trboxMapper.trboxdocnoUpdate(map);
		}
		return trboxno;
	}

	@Override
	public void getUpdateKeepReleaseRemove(Map<String, Object> params) throws Exception {
		trboxMapper.getUpdateKeepReleaseRemove(params);
		
	}

	@Override
	public void getCloseReopn(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		trboxMapper.getCloseReopn(params);
	}

	@Override
	public List<EgovMap> selectTrboxManagement(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		trboxMapper.updateTrboxInfo(params);
		return trboxMapper.selectTrboxManagementList(params);
	}
	
	@Override
	public List<EgovMap> selectTransferCodeList(Map<String, Object> params) {
		
		List<EgovMap> list = null;
		if ("branch".equals((String)params.get("groupCode"))){
			list = trboxMapper.selectBranchList(params); 
		}else if ("courier".equals((String)params.get("groupCode"))){
			list = trboxMapper.selectCourierList(params); 
		}
		
		return list;
	}

	@Override
	public String getTrBoxSingleTransfer(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		//MSC0034D Table insert
		
		String transitNo = "";
		Map<String, Object> map = trboxMapper.selectTrboxManageBoxNo("76");
		
		transitNo = (String)map.get("docfullno");
				
		String trsnid = (String)trboxMapper.selectTransferId();
		Map<String, Object> tranM = params;
		tranM.put("trsnid"  , trsnid);
		tranM.put("typeid"  , 750);
		tranM.put("statusid", 1);
		tranM.put("closedt" , "19000101");
		tranM.put("refno"   , (String)map.get("docfullno"));
		
		trboxMapper.transferMaterInsert(tranM);
		
		Map<String, Object> tranD = params;
		tranD.put("trsnid"    , trsnid);
		tranD.put("statusid"  , 1);
		tranD.put("restatusid", 44);
		
		trboxMapper.transferDetailInsert(tranD);
		
		Map<String, Object> trancard = params;
		trancard.put("refno"   , (String)map.get("docfullno"));
		trancard.put("typeid"  , 769);
		trancard.put("statusid", 1);
		trancard.put("qty", -1);
		trancard.put("locid", (String)params.get("tbrnch"));
		trboxMapper.transferRecordCardInsert(trancard);
		
		Map<String, Object> tranpos = params;
		tranpos.put("refno"   , (String)map.get("docfullno"));
		tranpos.put("typeid"  , 769);
		tranpos.put("statusid", 1);
		tranpos.put("qty", 1);
		tranpos.put("locid", (String)params.get("tcourier"));
		trboxMapper.transferRecordCardInsert(tranpos);
				
		trboxMapper.trboxdocnoUpdate(map);
		
		return transitNo;
	}
	
	@Override
	public List<EgovMap> selectTrboxReceiveList(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return trboxMapper.selectTrboxReceiveList(params);
	}
	
	@Override
	public Map<String, Object> selectReceiveViewData(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		Map<String, Object> remap = new HashMap();
		Map<String, Object> vimap = trboxMapper.selectReceiveViewData(params);
		remap.put("viewdata", vimap);
		Map<String, Object> cntmap = trboxMapper.selectReceiveViewCnt(params);
		remap.put("cntmap", cntmap);
		List<EgovMap> list = trboxMapper.selectReceiveViewList(params);
		remap.put("listmap", list);
		return remap;
	}

	@Override
	public List<EgovMap> getSearchTrboxReceiveGridList(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return trboxMapper.selectReceiveViewList(params);
	}

}
