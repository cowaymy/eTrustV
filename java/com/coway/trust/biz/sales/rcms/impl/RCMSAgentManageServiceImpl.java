package com.coway.trust.biz.sales.rcms.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.rcms.RCMSAgentManageService;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("rcmsAgentManageService")
public class RCMSAgentManageServiceImpl extends EgovAbstractServiceImpl  implements RCMSAgentManageService{


	@Resource(name = "rcmsAgentManageMapper")
	private RCMSAgentManageMapper rcmsAgentManageMapper;

	// DataBase message accessor....
	@Autowired
	private MessageSourceAccessor messageAccessor;


	private static final Logger LOGGER = LoggerFactory.getLogger(RCMSAgentManageServiceImpl.class);

	@Override
	public List<EgovMap> selectAgentTypeList(Map<String, Object> params) throws Exception {

		return rcmsAgentManageMapper.selectAgentTypeList(params);
	}

	@Override
	public List<Object> checkWebId(Map<String, Object> params) throws Exception {

		List<Object> rtnList = new ArrayList<Object>();

		List<Object> addList = (List<Object>)params.get("add");
		List<Object> updList = (List<Object>)params.get("upd");

		if(addList != null && addList.size() > 0){

			for (int idx = 0; idx < addList.size(); idx++) {

				Map<String, Object> addMap = (Map<String, Object>)addList.get(idx);
				EgovMap rtnMap = null;
				rtnMap = rcmsAgentManageMapper.chkUserNameByUserId(addMap);
				if(rtnMap == null){
					rtnList.add(addMap.get("userId"));
				}
			}
		}

		if(updList != null && updList.size() > 0){
			for (int idx = 0; idx < updList.size(); idx++) {

				Map<String, Object> addMap = (Map<String, Object>)updList.get(idx);
				EgovMap rtnMap = null;
				rtnMap = rcmsAgentManageMapper.chkUserNameByUserId(addMap);
				if(rtnMap == null){
					rtnList.add(addMap.get("userId"));
				}
			}
		}

		return rtnList;
	}

	@Override
	@Transactional
	public void insUpdAgent(Map<String, Object> params) throws Exception {

		List<Object> addList = (List<Object>)params.get("add");
		List<Object> updList = (List<Object>)params.get("upd");

		//__________________________________________________________________________________Add
		if(addList != null && addList.size() > 0){

			for (int idx = 0; idx < addList.size(); idx++) {

				Map<String, Object> addMap = (Map<String, Object>)addList.get(idx);

				//params Set
				Map<String, Object> insMap = new HashMap<String, Object>();
				int agentSeq = 0;
				agentSeq = rcmsAgentManageMapper.getSeqSAL0148M();
				insMap.put("agentSeq", agentSeq);
				insMap.put("agentGrpId", Integer.parseInt(String.valueOf(addMap.get("agentGrpId"))));
				insMap.put("agentType", Integer.parseInt(String.valueOf(addMap.get("agentType"))));
				insMap.put("agentName", addMap.get("agentName"));
				insMap.put("stusId", Integer.parseInt(String.valueOf(addMap.get("stusId"))));
				insMap.put("userId", 	addMap.get("userId"));
				insMap.put("crtUserId", params.get("crtUserId"));

				rcmsAgentManageMapper.insAgentMaster(insMap);

			}
		}

		//__________________________________________________________________________________Update
		if(updList != null && updList.size() > 0){
			for (int idx = 0; idx < updList.size(); idx++) {

				Map<String, Object> editMap = (Map<String, Object>)updList.get(idx);

				//params Set
				Map<String, Object> updMap = new HashMap<String, Object>();
				updMap.put("agentType", Integer.parseInt(String.valueOf(editMap.get("agentType"))));
				updMap.put("agentName", editMap.get("agentName"));
				updMap.put("stusId", Integer.parseInt(String.valueOf(editMap.get("stusId"))));
				updMap.put("userId", editMap.get("userId"));
				updMap.put("crtUserId", params.get("crtUserId"));
				updMap.put("agentId", Integer.parseInt(String.valueOf(editMap.get("agentId"))));
				updMap.put("agentGrpId", Integer.parseInt(String.valueOf(editMap.get("agentGrpId"))));

				rcmsAgentManageMapper.updAgentMaster(updMap);

			}
		}
	}

	@Override
	public List<Object> chkDupWebId(Map<String, Object> params) throws Exception {
		List<Object> rtnList = new ArrayList<Object>();

		List<Object> addList = (List<Object>)params.get("add");

		if(addList != null && addList.size() > 0){

			for (int idx = 0; idx < addList.size(); idx++) {

				Map<String, Object> addMap = (Map<String, Object>)addList.get(idx);
				EgovMap rtnMap = null;
				rtnMap = rcmsAgentManageMapper.chkDupWebId(addMap);
				if(rtnMap != null){
					rtnList.add(addMap.get("userId"));
				}
			}
		}

		return rtnList;
	}

	@Override
	public List<EgovMap> selectAgentList(Map<String, Object> params) throws Exception {

		return rcmsAgentManageMapper.selectAgentList(params);
	}

	@Override
	public List<EgovMap> selectAgentGrpList(Map<String, Object> params) throws Exception {
		LOGGER.debug("HERE -> {}", params);
		return rcmsAgentManageMapper.selectAgentGrpList(params);
	}



	@Override
	public List<EgovMap> selectRosCaller(Map<String, Object> params) {
		return rcmsAgentManageMapper.selectRosCaller(params);
	}

	@Override
	public List<EgovMap> selectAssignAgentList(Map<String, Object> params) {
		return rcmsAgentManageMapper.selectAssignAgentList(params);
	}

	@Override
	public void saveAssignAgent(Map<String, Object> params) {

		List<EgovMap> updateItemList = (List<EgovMap>) params.get(AppConstants.AUIGRID_UPDATE);

		int o=0;
    	if (updateItemList.size() > 0) {
			for (int i = 0; i < updateItemList.size(); i++) {
				Map<String, Object> updateMap = (Map<String, Object>) updateItemList.get(i);

				updateMap.put("userId", params.get("userId"));

				o = rcmsAgentManageMapper.updateAgent(updateMap) ;
				rcmsAgentManageMapper.updateCompany(updateMap) ;
			}
		}

	}


	@Override
	public List<EgovMap> checkAssignAgentList(Map<String, Object> params) {

		List<Object> list = (List<Object>) params.get(AppConstants.AUIGRID_ALL);
		Map<String, Object>  formData = (Map<String, Object>) params.get("formData");
		String rcmsUploadType = formData.get("rcmsUploadType2").toString();
		String msg = null;

		List checkList = new ArrayList();

		for (Object obj : list)
		{
			LOGGER.debug(" >>>>> checkAssignAgentList ");
			LOGGER.debug(" OrderNo : {}", ((Map<String, Object>) obj).get("0"));
			LOGGER.debug(" Agent ID : {}", ((Map<String, Object>) obj).get("1"));

			EgovMap result = new EgovMap();

			if(!CommonUtils.isEmpty(((Map<String, Object>) obj).get("0"))){

				result.put("orderNo", String.format("%07d", Integer.parseInt(((Map<String, Object>) obj).get("0").toString())));
				result.put("updateField", ((Map<String, Object>) obj).get("1"));
				result.put("rem", ((Map<String, Object>) obj).get("2"));

				((Map<String, Object>) obj).put("orderNo", result.get("orderNo"));
                ((Map<String, Object>) obj).put("updateField", result.get("updateField"));
				//check OrderNo
				if(rcmsAgentManageMapper.checkOrderNo(result) <= 0){
					msg = messageAccessor.getMessage(SalesConstants.MSG_INV_ORDNO);
					((Map<String, Object>) obj).put("msg", msg);
				}

				//check Agent ID
		        if(rcmsUploadType.equals("5525")){
    				if(rcmsAgentManageMapper.checkAgentId(result) <= 0){
    					msg = messageAccessor.getMessage(SalesConstants.MSG_INV_AGENTID);
    					((Map<String, Object>) obj).put("msg", msg);
    				}
		        }

		        checkList.add(obj);
		        continue;
			}
		}

		return checkList;
	}

	@Override
	public void saveAgentList(Map<String, Object> params) {
		List<Object> list = (List<Object>) params.get(AppConstants.AUIGRID_ALL);
		Map<String, Object>  formData = (Map<String, Object>) params.get("formData");
		String rcmsUploadType = formData.get("rcmsUploadType").toString();
		for (Object obj : list)
		{
		  LOGGER.debug("@@@@@@@ :" + obj.toString());
			EgovMap updateMap = new EgovMap();

			if(!CommonUtils.isEmpty(((Map<String, Object>) obj).get("0"))){
    			updateMap.put("orderNo", String.format("%07d", Integer.parseInt(((Map<String, Object>) obj).get("0").toString())));
    			updateMap.put("updateField", ((Map<String, Object>) obj).get("1"));
    			updateMap.put("rem", ((Map<String, Object>) obj).get("2"));
    			updateMap.put("userId", params.get("userId"));

    			updateMap.put("rcmsUploadType", rcmsUploadType);

    			EgovMap map = rcmsAgentManageMapper.selectRcmsInfo(updateMap);

    			updateMap.put("salesOrdId", map.get("salesOrdId"));
    			updateMap.put("prevAgentId", map.get("agentId"));

    			rcmsAgentManageMapper.updateAgent(updateMap);
			}
		}
	}

	@Override
	public void updateRemark(Map<String, Object> params) {
		rcmsAgentManageMapper.updateRemark(params);
	}

	@Override
	public EgovMap selectRcmsInfo(Map<String, Object> params) {
		return rcmsAgentManageMapper.selectRcmsInfo(params);
	}

	@Override
	public List<EgovMap> selectAssignConvertList(Map<String, Object> params) {
		return rcmsAgentManageMapper.selectAssignConvertList(params);
	}

	@Override
	public List<EgovMap> selectAssignConvertItemList(Map<String, Object> params) {
	    return rcmsAgentManageMapper.selectAssignConvertItemList(params);
	}

	@Override
	public List<EgovMap> selectRosCallDetailList(Map<String, Object> params) {
		return rcmsAgentManageMapper.selectRosCallDetailList(params);
	}

	@Override
	public List<EgovMap> rentalStatusListForBadAcc(Map<String, Object> params) {

		return rcmsAgentManageMapper.rentalStatusListForBadAcc(params);
	}

  @Override
  public List<EgovMap> checkCustAgent(Map<String, Object> params) {
    return rcmsAgentManageMapper.checkCustAgent(params);
  }

  @Override
  public void insertUploadedConversionList(Map<String, Object> params) {
    rcmsAgentManageMapper.insertUploadedConversionList(params);
  }

  @Override
  public void deleteUploadedConversionList(Map<String, Object> params) {
    rcmsAgentManageMapper.deleteUploadedConversionList(params);
  }

  @Override
  public List<EgovMap> selectUploadedConversionList(Map<String, Object> params) {
    return rcmsAgentManageMapper.selectUploadedConversionList(params);
  }

  @SuppressWarnings("unchecked")
  @Override
  public void saveConversionList(Map<String, Object> params) {
      List<Object> list = (List<Object>) params.get(AppConstants.AUIGRID_ALL);
      Map<String, Object>  formData = (Map<String, Object>) params.get("formData");
      String rcmsUploadType = formData.get("rcmsUploadType2").toString();
      String assignUploadType = formData.get("assignUploadType").toString();

      Map<String, Object> bulkMap = new HashMap<>();

      String seqSAL0239D = rcmsAgentManageMapper.select_SeqSAL0239D(params);
      params.put("rcBatchNo", seqSAL0239D);
      params.put("stusId", 1);
      params.put("rcmsUploadType", rcmsUploadType);
      params.put("assignUploadType", assignUploadType);

      rcmsAgentManageMapper.insert_SAL0239D(params);

      bulkMap.put("seq", seqSAL0239D);
      bulkMap.put("userId", params.get("userId"));
      rcmsAgentManageMapper.insert_SAL0240D(bulkMap);

  }


	@Override
	public List<EgovMap> selectAgentGroupList(Map<String, Object> params) throws Exception {

		return rcmsAgentManageMapper.selectAgentGroupList(params);
	}

	@Override
	@Transactional
	public void insUpdAgentGroup(Map<String, Object> params) throws Exception {

		List<Object> addList = (List<Object>)params.get("add");
		List<Object> updList = (List<Object>)params.get("upd");

		//__________________________________________________________________________________Add
		if(addList != null && addList.size() > 0){

			for (int idx = 0; idx < addList.size(); idx++) {

				Map<String, Object> addMap = (Map<String, Object>)addList.get(idx);

				//params Set
				Map<String, Object> insMap = new HashMap<String, Object>();

				int agentGrpSeq = 0;
				agentGrpSeq = rcmsAgentManageMapper.getSeqSAL0324M();

				insMap.put("agentGrpId", agentGrpSeq);
				insMap.put("agentGrpName", addMap.get("agentGrpName"));

				rcmsAgentManageMapper.insAgentGroupMaster(insMap);

			}
		}

		//__________________________________________________________________________________Update
		if(updList != null && updList.size() > 0){
			for (int idx = 0; idx < updList.size(); idx++) {

				Map<String, Object> editMap = (Map<String, Object>)updList.get(idx);

				//params Set
				Map<String, Object> updMap = new HashMap<String, Object>();
				updMap.put("agentGrpName", editMap.get("agentGrpName"));;
				updMap.put("agentGrpId", Integer.parseInt(String.valueOf(editMap.get("agentGrpId"))));

				rcmsAgentManageMapper.updAgentGroupMaster(updMap);

			}
		}
	}




}
