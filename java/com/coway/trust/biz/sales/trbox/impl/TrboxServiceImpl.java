package com.coway.trust.biz.sales.trbox.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
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
		tranD.put("closedt"    , "19000101");

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

	@Override
	public Map<String, Object> postTrboxReceiveInsertData(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		// postTrboxReceiveInsertData

		List<Object> insList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
		List<Object> updList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
		List<Object> remList = (List<Object>) params.get(AppConstants.AUIGRID_REMOVE);
		int userid = (int)params.get("userid");

		Map<String, Object> form = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);

		String targetLocation = "";
		if ("4".equals((String)form.get("utrnstatuslist"))){
			targetLocation = (String)form.get("receiver");
		}else{
			targetLocation = (String)form.get("sender");
		}

		for (int i = 0 ; i < insList.size() ; i++){
			Map<String, Object> imap = (Map<String, Object>) insList.get(i);
			logger.debug(" ::: {}" ,  imap);
			Map<String, Object> pmap = new HashMap();
			pmap.put("trboxid", imap.get("TBI"));
			pmap.put("trtypeid", 769);
			pmap.put("trlocation", targetLocation);
			pmap.put("trstatusid", 1);
			pmap.put("userid", userid);
			pmap.put("trqty", 1);
			pmap.put("refno", form.get("transitno"));

			trboxMapper.receiveTrboxRecordCardInsert(pmap);

			pmap.put("trlocation", form.get("courier"));
			pmap.put("trqty", 1);

			trboxMapper.receiveTrboxRecordCardInsert(pmap);

			pmap.put("transitditid", imap.get("TTDI"));
			pmap.put("resultstaus", form.get("utrnstatuslist"));

			trboxMapper.updateTrboxTransitDetail(pmap);

		}

		int cnt = trboxMapper.selectTrBoxTransitDsCnt((String)form.get("transitid"));
		Map<String, Object> pmap = new HashMap();
		pmap.put("userid", userid);
		pmap.put("trnsitid", form.get("transitid"));

		if (cnt == 0 ){
			if (!"36".equals((String)form.get("transitstatus"))){
				pmap.put("status", 36);
				trboxMapper.TRBoxTransitMasterUpdate(pmap);
			}
		}else{
			if ("1".equals((String)form.get("transitstatus"))){
				pmap.put("status", 44);
				trboxMapper.TRBoxTransitMasterUpdate(pmap);
			}
		}
		pmap.put("code", "000");
		return pmap;
	}

	@Override
	public Map<String, Object> postTrboxTransferInsertData(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		List<Object> insList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
		int userid = (int)params.get("userid");
		Map<String, Object> form = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);

		String transitNo = "";
		// DOC NO
		Map<String, Object> map = trboxMapper.selectTrboxManageBoxNo("76");

		transitNo = (String)map.get("docfullno");

		String trsnid = (String)trboxMapper.selectTransferId();
		Map<String, Object> tranM = new HashMap();
		tranM.put("trsnid"     , trsnid);
		tranM.put("typeid"     , 750);
		tranM.put("statusid"   , 1);
		tranM.put("closedt"    , "19000101");
		tranM.put("tranholder" , form.get("sender"));
		tranM.put("tbrnch"     , form.get("receiver"));
		tranM.put("tcourier"   , form.get("courier"));
		tranM.put("refno"      , (String)map.get("docfullno"));
		tranM.put("userid"     , userid);

		trboxMapper.transferMaterInsert(tranM);

		for (int i = 0 ; i < insList.size(); i++){
			Map<String, Object> ins = (Map<String, Object>)insList.get(i);
			Map<String, Object> tranD = new HashMap();
			tranD.put("trsnid"     , trsnid);
			tranD.put("tranboxid"  , ins.get("boxid"));
			tranD.put("statusid"   , 1);
			tranD.put("restatusid" , 44);
			tranD.put("closedt"    , "19000101");
			tranD.put("userid"     , userid);

			trboxMapper.transferDetailInsert(tranD);

			Map<String, Object> trancard = new HashMap();
			trancard.put("tranboxid"  , ins.get("boxid"));
			trancard.put("refno"   , map.get("docfullno"));
			trancard.put("typeid"  , 769);
			trancard.put("statusid", 1);
			trancard.put("qty"     , -1);
			trancard.put("locid"   , form.get("sender"));
			trancard.put("userid"  , userid);
			trboxMapper.transferRecordCardInsert(trancard);

			trancard.put("qty"     , 1);
			trancard.put("locid"   , form.get("receiver"));

			trboxMapper.transferRecordCardInsert(trancard);

		}

		trboxMapper.trboxdocnoUpdate(map);
		map.put("code", "000");
		return map;
	}

	@Override
	public List<EgovMap> selectUnkeepTRBookList(Map<String, Object> params) throws Exception {
		// TODO Auto-generated method stub
		return trboxMapper.selectUnkeepTRBookList(params);
	}

	@Override
	public void KeepAddTRBookInsert(Map<String, Object> params) throws Exception {
		trboxMapper.KeepAddTRBookInsert(params);

	}

}
