package com.coway.trust.biz.organization.training.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.organization.training.TrainingService;
import com.coway.trust.biz.sales.ccp.impl.CcpAgreementServieImpl;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("trainingService")
public class TrainingServiceImpl implements TrainingService {

	private static final Logger Logger = LoggerFactory.getLogger(CcpAgreementServieImpl.class);

	@Resource(name = "trainingMapper")
	private TrainingMapper trainingMapper;

	@Override
	public List<EgovMap> selectCourseList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		Logger.debug("params =====================================>>  " + params);

		List<EgovMap> courseList = trainingMapper.selectCourseList(params);

//		for(int i = 0; i < courseList.size(); i++) {
//			List<EgovMap> attendeeList = trainingMapper.selectAttendeeList(courseList.get(i));
//			// 총 참가자
//			courseList.get(i).put("total", attendeeList.size());
//
//			// 초기화
//			int passed = 0;
//			int failed = 0;
//			int absent = 0;
//			int others = 0;
//
//			for(int j = 0; j < attendeeList.size(); j++) {
//				if("P".equals(attendeeList.get(j).get("coursTestResult"))) {
//					passed = passed + 1;
//				} else if("F".equals(attendeeList.get(j).get("coursTestResult"))) {
//					failed = failed + 1;
//				} else if("AB".equals(attendeeList.get(j).get("coursTestResult"))) {
//					absent = absent + 1;
//				} else if(!"P".equals(attendeeList.get(j).get("coursTestResult")) && !"F".equals(attendeeList.get(j).get("coursTestResult")) && "AB".equals(attendeeList.get(j).get("coursTestResult"))) {
//					others = others + 1;
//				}
//			}
//
//			courseList.get(i).put("passed", passed);
//			courseList.get(i).put("failed", failed);
//			courseList.get(i).put("absent", absent);
//			courseList.get(i).put("others", others);
//		}

		return courseList;
	}

	@Override
	public List<EgovMap> selectCourseStatusList() {
		// TODO Auto-generated method stub
		return trainingMapper.selectCourseStatusList();
	}

	@Override
	public List<EgovMap> selectCourseTypeList() {
		// TODO Auto-generated method stub
		return trainingMapper.selectCourseTypeList();
	}

	@Override
	public List<EgovMap> selectAttendeeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return trainingMapper.selectAttendeeList(params);
	}

	@Override
	public EgovMap selectBranchByMemberId(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return trainingMapper.selectBranchByMemberId(params);
	}

	@Override
	public void updateCourseForLimitStatus(Map<String, Object> params) {
		// TODO Auto-generated method stub
		Logger.debug("params =====================================>>  " + params);

		List<Object> updateList = (List<Object>) params.get("update"); // 수정 리스트 얻기

		if (updateList.size() > 0) {
			Map hm = null;

			for (Object map : updateList) {
				hm = (HashMap<String, Object>) map;
				hm.put("userId", params.get("userId"));
				Logger.debug("updateCourse =====================================>>  " + hm);
				trainingMapper.updateCourse(hm);

				if(hm.get("coursCode").toString().contains("ROA") && "4".equals(hm.get("stusCodeId"))) {
				    trainingMapper.updateRookie(hm);
				}
			}
		}

		Logger.info("수정 : {}", updateList.toString());
	}

	@Override
	public void updateAttendee(Map<String, Object> params) {
		// TODO Auto-generated method stub
		Logger.debug("params =====================================>>  " + params);

		Map<String, Object> gridData = (Map<String, Object>) params.get("gridData");

		List<Object> addList = (List<Object>) gridData.get("add"); // 추가 리스트 얻기
		List<Object> updateList = (List<Object>) gridData.get("update"); // 수정 리스트 얻기
		List<Object> removeList = (List<Object>) gridData.get("remove"); // 제거 리스트 얻기

		if (addList.size() > 0) {
			Map hm = null;
			// biz처리
			for (Object map : addList) {
				hm = (HashMap<String, Object>) map;
				hm.put("coursId", params.get("coursId"));
				hm.put("userId", params.get("userId"));
				Logger.debug("insertAttendee =====================================>>  " + hm);
				trainingMapper.insertAttendee(hm);
			}
		}
		if (updateList.size() > 0) {
			Map hm = null;

			for (Object map : updateList) {
				hm = (HashMap<String, Object>) map;
				hm.put("userId", params.get("userId"));
				Logger.debug("updateAttendee =====================================>>  " + hm);
				trainingMapper.updateAttendee(hm);
			}
		}
		if (removeList.size() > 0) {
			Map hm = null;

			for (Object map : removeList) {
				hm = (HashMap<String, Object>) map;
				Logger.debug("deleteAttendee =====================================>>  " + hm);
				//trainingMapper.deleteAttendee(hm);
				trainingMapper.inactiveAttendee(hm);
			}
		}

		Logger.info("추가 : {}", addList.toString());
		Logger.info("수정 : {}", updateList.toString());
		Logger.info("삭제 : {}", removeList.toString());
	}

	@Override
	public int selectNextCoursId() {
		// TODO Auto-generated method stub
		return trainingMapper.selectNextCoursId();
	}

	@Override
	public void insertCourse(Map<String, Object> params) {
		// TODO Auto-generated method stub
		Logger.debug("params =====================================>>  " + params);

		trainingMapper.insertCourse(params);

		Map<String, Object> gridData = (Map<String, Object>) params.get("gridData");

		List<Object> addList = (List<Object>) gridData.get("add"); // 추가 리스트 얻기

		if (addList.size() > 0) {
			Map hm = null;
			// biz처리
			for (Object map : addList) {
				hm = (HashMap<String, Object>) map;
				hm.put("coursId", params.get("coursId"));
				hm.put("userId", params.get("userId"));
				Logger.debug("insertAttendee =====================================>>  " + hm);
				trainingMapper.insertAttendee(hm);
			}
		}

		Logger.info("추가 : {}", addList.toString());
	}

	@Override
	public void insertAttendee(Map<String, Object> params) {
		// TODO Auto-generated method stub
		trainingMapper.insertAttendee(params);
	}

	@Override
	public void deleteAttendee(Map<String, Object> params) {
		// TODO Auto-generated method stub
		trainingMapper.deleteAttendee(params);
	}

	@Override
	public List<EgovMap> getUploadMemList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return trainingMapper.getUploadMemList(params);
	}

	@Override
	public EgovMap selectCourseInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return trainingMapper.selectCourseInfo(params);
	}

	@Override
	public void updateCourse(Map<String, Object> params) {
		// TODO Auto-generated method stub
		Logger.debug("params =====================================>>  " + params);

		trainingMapper.updateCourse(params);

		Map<String, Object> gridData = (Map<String, Object>) params.get("gridData");

		List<Object> addList = (List<Object>) gridData.get("add"); // 추가 리스트 얻기
		List<Object> updateList = (List<Object>) gridData.get("update"); // 수정 리스트 얻기
		List<Object> removeList = (List<Object>) gridData.get("remove"); // 제거 리스트 얻기

		if (addList.size() > 0) {
			Map hm = null;
			// biz처리
			for (Object map : addList) {
				hm = (HashMap<String, Object>) map;
				hm.put("coursId", params.get("coursId"));
				hm.put("userId", params.get("userId"));
				Logger.debug("insertAttendee =====================================>>  " + hm);
				trainingMapper.insertAttendee(hm);
			}
		}
		if (updateList.size() > 0) {
			Map hm = null;

			for (Object map : updateList) {
				hm = (HashMap<String, Object>) map;
				hm.put("userId", params.get("userId"));
				Logger.debug("updateAttendee =====================================>>  " + hm);
				trainingMapper.updateAttendee(hm);
			}
		}
		if (removeList.size() > 0) {
			Map hm = null;

			for (Object map : removeList) {
				hm = (HashMap<String, Object>) map;
				Logger.debug("deleteAttendee =====================================>>  " + hm);
				trainingMapper.deleteAttendee(hm);
			}
		}

		Logger.info("추가 : {}", addList.toString());
		Logger.info("수정 : {}", updateList.toString());
		Logger.info("삭제 : {}", removeList.toString());
	}

	@Override
	public String selectLoginUserNric(int userId) {
		// TODO Auto-generated method stub
		return trainingMapper.selectLoginUserNric(userId);
	}

	@Override
	public int selectLoginUserMemId(int userId) {
		// TODO Auto-generated method stub
		return trainingMapper.selectLoginUserMemId(userId);
	}

	@Override
	public List<EgovMap> selectApplicantLog(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return trainingMapper.selectApplicantLog(params);
	}

	@Override
	public List<EgovMap> chkNewAttendList(Map<String, Object> params) {
		List<Object> list = (List<Object>) params.get(AppConstants.AUIGRID_ALL);
		Map<String, Object> formData =  (Map<String, Object>) params.get("form");

		EgovMap result = new EgovMap();

		String msg = null;

		Map<String, Object> map = new HashMap();

		String chkFlag = "N";
		int yn = Integer.parseInt((String)formData.get("memTypeYN"));
		List checkList = new ArrayList();

		for (Object obj : list)
		{
			((Map<String, Object>) obj).put("userId", params.get("userId"));

			Logger.debug(" nric : {}", ((Map<String, Object>) obj).get("0"));
			Logger.debug(" result : {}", (Map<String, Object>) params.get("form"));
			Logger.debug(" coursId : {}", formData.get("coursId"));
			params.put("nric", ((Map<String, Object>) obj).get("0"));
			params.put("coursId", formData.get("coursId"));

			if(!StringUtils.isEmpty(params.get("nric"))){
				((Map<String, Object>) obj).put("nric",  ((Map<String, Object>) obj).get("0"));

				if("VIEW".equals(params.get("btnFlag"))){
					int info = trainingMapper.courseNricDup(params);
					if(info < 1){
						chkFlag = "N";
					}else{
						chkFlag = "Y";
					}
				}

				((Map<String, Object>) obj).put("chkFlag", chkFlag);
				if( yn == 2318){
					((Map<String, Object>) obj).put("memCode", ((Map<String, Object>) obj).get("0"));
				}else{
					((Map<String, Object>) obj).put("coursDMemName", ((Map<String, Object>) obj).get("0"));
				}
				((Map<String, Object>) obj).put("coursDMemNric", ((Map<String, Object>) obj).get("1"));
				((Map<String, Object>) obj).put("coursMemShirtSize", ((Map<String, Object>) obj).get("2"));
//				((Map<String, Object>) obj).put("appTypeCode", info.get("appTypeCode"));
//				((Map<String, Object>) obj).put("rentalStus", info.get("rentalStus"));
//				Logger.debug("info ================>>  " + info.get("ordNo"));
//				Logger.debug("info ================>>  " + info.get("ordStusCode"));
//				Logger.debug("info ================>>  " + info.get("appTypeCode"));
//				Logger.debug("info ================>>  " + info.get("rentalStus"));
				checkList.add(obj);
				continue;
			}
		}
		return checkList;
	}

	@Override
	public List<EgovMap> selectCourseRequestList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return trainingMapper.selectCourseRequestList(params);
	}


	@Override
	public List<EgovMap> selectMyAttendeeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return trainingMapper.selectMyAttendeeList(params);
	}


	@Override
	public EgovMap selectMemInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return trainingMapper.selectMemInfo(params);
	}


	@Override
	public void registerCourseReq(Map<String, Object> params) {
		// TODO Auto-generated method stub
		trainingMapper.registerCourseReq(params);
	}


	@Override
	public void cancelCourseReq(Map<String, Object> params) {
		// TODO Auto-generated method stub
		trainingMapper.cancelCourseReq(params);
	}


	@Override
	public EgovMap getMemCodeForCourse(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return trainingMapper.getMemCodeForCourse(params);
	}
}
