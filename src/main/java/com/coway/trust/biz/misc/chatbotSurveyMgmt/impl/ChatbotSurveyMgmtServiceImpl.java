package com.coway.trust.biz.misc.chatbotSurveyMgmt.impl;


import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.joda.time.LocalDate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.misc.chatbotSurveyMgmt.ChatbotSurveyMgmtService;
import com.coway.trust.biz.misc.chatbotSurveyMgmt.impl.ChatbotSurveyMgmtMapper;
import com.coway.trust.biz.misc.chatbotSurveyMgmt.impl.ChatbotSurveyMgmtServiceImpl;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.ibm.icu.text.SimpleDateFormat;
import com.ibm.icu.util.Calendar;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("chatbotSurveyMgmtService")
public class ChatbotSurveyMgmtServiceImpl extends EgovAbstractServiceImpl implements ChatbotSurveyMgmtService{
	private static final Logger LOGGER = LoggerFactory.getLogger(ChatbotSurveyMgmtServiceImpl.class);

	@Resource(name = "chatbotSurveyMgmtMapper")
	private ChatbotSurveyMgmtMapper chatbotSurveyMgmtMapper;

	@Override
    public List<EgovMap> selectChatbotSurveyType(Map<String, Object> params) {
        return chatbotSurveyMgmtMapper.selectChatbotSurveyType(params);
    }

	@Override
	public List<EgovMap> selectChatbotSurveyMgmtList(Map<String, Object> params) {
		return chatbotSurveyMgmtMapper.selectChatbotSurveyMgmtList(params);
	}

	@Override
    public List<EgovMap> selectChatbotSurveyDesc(Map<String, Object> params) {
        return chatbotSurveyMgmtMapper.selectChatbotSurveyDesc(params);
    }

	@Override
	public List<EgovMap> selectChatbotSurveyMgmtEdit(Map<String, Object> params) {
		return chatbotSurveyMgmtMapper.selectChatbotSurveyMgmtEdit(params);
	}

	@Override
	public void saveSurveyDetail(Map<String, Object> params, SessionVO sessionVO) {

		Date today = new Date();
        String targetQuesStr = null;

    	//Get first day of the next month
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(today);

        calendar.add(Calendar.MONTH, 1);
        calendar.set(Calendar.DAY_OF_MONTH, 1);

        Date firstDayOfNextMonth = calendar.getTime();
        targetQuesStr = new SimpleDateFormat("yyyyMMdd").format(firstDayOfNextMonth);

		// ============================
		// Get and update existing questions :: Start
		// ============================
		// GET EIXST SURVEY QUESTION
		List<EgovMap> result = null;
		EgovMap updateInfo = new EgovMap();

		int categoryDt = chatbotSurveyMgmtMapper.getCategoryDate(params.get("id").toString());

		if(categoryDt > 0){

	        updateInfo.put("sysDt",targetQuesStr);
		 	updateInfo.put("ctrlId", params.get("id").toString());
		 	updateInfo.put("survGrpId", params.get("survGrpId").toString());

		 	//Get valid existing Surv_id
		 	Object[] existSurveyQuesList = chatbotSurveyMgmtMapper.getExistTargetQuestion(updateInfo).toArray();

			if(existSurveyQuesList.length > 0){
				String[] survIdArray = Arrays.copyOf(existSurveyQuesList, existSurveyQuesList.length, String[].class);
				updateInfo.put("survIdArray", survIdArray);

				String targetQuesStrDt = chatbotSurveyMgmtMapper.getTargetQuesStrDt(updateInfo);


				if(targetQuesStrDt.equals(targetQuesStr)){
					//Update exist target question's end date to yesterday

					Calendar calendar2 = Calendar.getInstance();
					calendar2.setTime(today);
					calendar2.add(Calendar.DATE, -1);

					Date yesterdayDt = calendar2.getTime();
					String yesterday = new SimpleDateFormat("yyyyMMdd").format(yesterdayDt);
					updateInfo.put("lastDay", yesterday);
				}else{
					// update ques end date to end of the month
					calendar.add(Calendar.DATE, -1);

					Date lastDayOfMonth = calendar.getTime();
			        String lastDay = new SimpleDateFormat("yyyyMMdd").format(lastDayOfMonth);

					updateInfo.put("lastDay", lastDay);
				}

				updateInfo.put("userId", sessionVO.getUserId());

				//Update existing target question
				chatbotSurveyMgmtMapper.updateExistTargetQues(updateInfo);

			}
		}
		// ===========================
		// Get and update existing questions :: End
		// ===========================


        // ==========================
        // Insert new question and answer :: Start
        // ==========================
		//Set end date for new survey question (get value from master table)
        String endDate = chatbotSurveyMgmtMapper.getSurveyEndDate(params.get("id").toString());
        String newEndDt = null;

        try {
			Date endDt = new SimpleDateFormat("yyyyMM").parse(endDate);
			Calendar c = Calendar.getInstance();
			c.setTime(endDt);
			c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));

			newEndDt = new SimpleDateFormat("yyyyMMdd").format(c);

		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

        // INSERT INTO CBT0002M
        List<Object> gridDataList = (List<Object>) params.get(AppConstants.AUIGRID_ALL);

     	Map<String, Object> gridData = null;

        // get next value of surv_grp_id
    	int nextSurvGrpId = chatbotSurveyMgmtMapper.getNextSurvGrpId(params.get("id").toString()) + 1;

        for(int i = 0 ; i < gridDataList.size() ; i++){
        	gridData = (Map<String, Object>) gridDataList.get(i);
        	gridData.put("userId", sessionVO.getUserId());
        	gridData.put("ctrlId", params.get("id").toString());
        	gridData.put("newStartDt", targetQuesStr);
        	gridData.put("newEndDt", newEndDt);
        	gridData.put("nextSurvGrpId", nextSurvGrpId);

        	// get cbt0002m nextval, coz need to insert 0003d togther
        	int nextSurvSeq = chatbotSurveyMgmtMapper.getNextSurvSeq();
        	gridData.put("nextSurvSeq", nextSurvSeq);

        	// Insert into CBT0002M
            chatbotSurveyMgmtMapper.insertNewSurveyQues(gridData);

        	// Insert into CBT0003D
        	if(gridData.get("codeId").toString().equals("7360")){ // SELECTION
        		String[] ansOptList = gridData.get("tmplAns").toString().split(",");

        		for(int j = 0 ; j < ansOptList.length; j++){
        			gridData.put("ansSeq", j+1);
        			gridData.put("ans1", ansOptList[j]);

        			// INSERT INTO CBT0003D
                	chatbotSurveyMgmtMapper.insertNewSurveyAns(gridData);
        		}

        	}else if (gridData.get("codeId").toString().equals("7361")){ // RATING
        		String[] ansOptList = gridData.get("tmplAns").toString().split(",");

        		gridData.put("ansSeq", 1);
        		gridData.put("ans1", ansOptList[0]);
        		gridData.put("ans2", ansOptList[1]);

        		// INSERT INTO CBT0003D
            	chatbotSurveyMgmtMapper.insertNewSurveyAns(gridData);

        	}else { // COMMENT
        		gridData.put("ansSeq", 1);
        		gridData.put("ans1", " ");

        		// INSERT INTO CBT0003D
            	chatbotSurveyMgmtMapper.insertNewSurveyAns(gridData);
        	}
        }
        // ==========================
        // Insert new question and answer :: End
        // ==========================
	}
}
