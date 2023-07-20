package com.coway.trust.biz.attendance.impl;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.apache.commons.collections.map.ListOrderedMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.attendance.AttendanceService;
import com.coway.trust.biz.payment.payment.service.ClaimResultUploadVO;
import com.coway.trust.biz.sample.impl.SampleServiceImpl;
import com.coway.trust.util.BeanConverter;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("AttendanceService")
public class AttendanceServiceImpl implements AttendanceService {

	private static final Logger LOGGER = LoggerFactory.getLogger(AttendanceServiceImpl.class);

    @Resource(name = "AttendanceMapper")
    private AttendanceMapper attendanceMapper;

    @Value("${epapan.auth}")
	private String epapanAuth;

    //@Transactional
	@Override
	public int saveCsvUpload(Map<String, Object> cvsParam) {

		try{

			int batchId =0, result = 0;

			batchId = attendanceMapper.selectCurrentBatchId();

			List<CalendarEventVO> vos = (List<CalendarEventVO>) cvsParam.get("voList");

		    List<Map> list = vos.stream().map(vo -> {Map<String, Object> hm = BeanConverter.toMap(vo);

		        String dateFrom = vo.getDateFrom().trim();
				String dateTo = vo.getDateTo().trim();
				String time = vo.getTime().trim();

				hm.put("atdType", vo.getAttendanceType().trim());
				hm.put("memCode", vo.getMemCode().trim());
				hm.put("managerCode", vo.getManagerCode());
				hm.put("dateFrom",dateFrom);
				hm.put("dateTo", dateTo);
				hm.put("time", time);
				hm.put("crtUserId", cvsParam.get("userId"));

		        return hm;
		      }).collect(Collectors.toList());
		    LOGGER.debug("paramslist  list =====================================>>  " + list);

			int size = 1000;
		    int page = list.size() / size;
		    int start;
		    int end;

		    Map<String, Object> bulkMap = new HashMap<>();
		    for (int i = 0; i <= page; i++) {
		      start = i * size;
		      end = size;
		      if (i == page) {
		        end = list.size();
		      }

		      bulkMap.put("list", list.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));

		      if(cvsParam.get("type")=="ins"){
			      bulkMap.put("batchId", batchId);
		      }else{
			      bulkMap.put("batchId", cvsParam.get("batchId"));
		      }

		      result = attendanceMapper.saveBatchCalDetailList(bulkMap);

		      	if(result<0){
					throw new Error("Unable to upload");
				}
		    }

			return batchId;
		}
		catch(Exception e){
			throw e;
		}
	}

	//@Transactional
	@Override
	public int saveBatchCalMst( Map<String, Object> master) {

		int result = attendanceMapper.saveBatchCalMst(master); // INSERT INTO ATD0001M
		return result;
	}


	@Override
	public int checkDup(Map<String, Object> master) {

		int mResult = attendanceMapper.checkDup(master);

		return mResult;
	}

	//@Transactional
	@Override
	public int disableBatchCalDtl(Map<String, Object> params) {

		int mResult = attendanceMapper.disableBatchCalDtl(params);

		return mResult;
	}

	public int disableBatchAtdRate(Map<String, Object> params) {

		int mResult = attendanceMapper.disableBatchAtdRate(params);

		return mResult;
	}


	 @Override
	  public List<EgovMap> searchAtdUploadList(Map<String, Object> params) {
	    return attendanceMapper.searchAtdUploadList(params);
	  }

	 //@Transactional
	 @Override
	  public void disableBatchCalMst(Map<String, Object> params) {
	      attendanceMapper.disableBatchCalMst(params);
	  }

	 //@Transactional
	 @Override
	  public int deleteUploadBatch(Map<String, Object> params) {

		  int result =	attendanceMapper.deleteUploadBatch(params);

		  return result;

	  }

	 @Override
	 public String atdMigrateMonth() {
		 return attendanceMapper.atdMigrateMonth();
	 }

	 //@Transactional
	 @Override
	 public int approveUploadBatch(Map<String, Object> params) {

    		int result =0,updResult = 0, atdRate = 0;

//    		try{
    		try {
    			if ((new SimpleDateFormat("dd/MM/yyyy").parse(attendanceMapper.atdMigrateMonth())).after(new SimpleDateFormat("MM/yyyy").parse((String) params.get("batchMthYear"))) == false) {
					result =	attendanceMapper.approveUploadBatch(params);
					List<EgovMap> transferData = attendanceMapper.getTransferData(params);
					List<Map<String, Object>> completeData = new ArrayList();
					transferData.stream().forEach((a) -> {
						try {
							Date from = new SimpleDateFormat("dd/MM/yyyy").parse((String) a.get("dtFrom"));
							Date to = new SimpleDateFormat("dd/MM/yyyy").parse((String) a.get("dtTo"));
							Calendar start = Calendar.getInstance();
							start.setTime(from);
							for (Calendar init = start; start.getTime().before(to); init.add(Calendar.DAY_OF_MONTH, 1)) {
								Map<String, Object> data = new HashMap();
								String month = ((String) params.get("batchMthYear")).substring(0, 2);
								String year = ((String) params.get("batchMthYear")).substring(3);
								data.put("attendBatchMonth", year + month);
								data.put("attendBatchSeq", a.get("batchId"));
								data.put("attendDate", new SimpleDateFormat("yyyyMMdd").format(init.getTime()));
								data.put("attendUserName", a.get("memCode"));
								data.put("attendDateTime", new SimpleDateFormat("yyyy/MM/dd").format(init.getTime()) + " " + a.get("time"));
								data.put("attendScanDevice", "");
								data.put("attendBranchCode", "");
								data.put("attendBranchName", "");
								data.put("attendBranchId", "");
								data.put("attendTypeCode", a.get("atdType"));
								data.put("attendTypeDesc", "");
								completeData.add(data);
							}
						} catch (Exception e) {
							e.printStackTrace();
						}
					});
					HttpURLConnection connection = (HttpURLConnection) new URL("https://epapanapis.malaysia.coway.do/apps/api/calendar/attendEvents").openConnection();
					connection.setDoOutput(true);
					byte[] inputData = new Gson().toJson(completeData).getBytes("utf-8");
					connection.setRequestMethod( "PUT" );
					connection.setRequestProperty("Content-Type", "application/json");
					connection.setRequestProperty("charset", "utf-8");
					connection.setRequestProperty("Authorization", epapanAuth);
				    connection.setRequestProperty("Content-Length", Integer.toString(inputData.length));
				    try(OutputStream os = connection.getOutputStream()) {
				    	os.write(inputData);
				    }
					BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
					String input;
					StringBuffer content = new StringBuffer();
					while ((input = in.readLine()) != null) {
						content.append(input);
					}
					in.close();
					Map<String, Object> res = (Map<String, Object>) new Gson().fromJson(content.toString(), new TypeToken<Map<String, Object>>() {}.getType());
					LOGGER.debug("##################### {}", new Gson().toJson(completeData));
					return result;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			result =	attendanceMapper.approveUploadBatch(params);
			updResult = attendanceMapper.updateManagerCode(params);
			attendanceMapper.atdRateCalculation(params);
//
			return result;

//    			if(result < 0 || updResult <0){
//    				throw new Error("Unable to approve upload batch");
//    			}
//    			else{
//    				return result;
//    			}
//
//    		}
//    		catch(Throwable ex){
//    			throw ex;
//    		}
	 }


	 @Override
	  public List<EgovMap> selectManagerCode(Map<String, Object> params) {
	    return attendanceMapper.selectManagerCode(params);
	 }

	 @Override
	  public List<EgovMap> searchAtdManagementList(Map<String, Object> params) {
	    return attendanceMapper.searchAtdManagementList(params);
	  }

	 @Override
	  public List<EgovMap> selectYearList(Map<String, Object> params) {
	    return attendanceMapper.selectYearList(params);
	 }

	 @Override
	 public List<EgovMap> getDownline(Map<String, Object> params) {
		 return attendanceMapper.getDownline(params);
	 }

	 @Override
	 public List<EgovMap> getDownlineHP(Map<String, Object> params) {
		 return attendanceMapper.getDownlineHP(params);
	 }

	 @Override
	 public List<EgovMap> getMemberInfo(Map<String, Object> params) {
		 return attendanceMapper.getMemberInfo(params);
	 }

	 @Override
	 public List<EgovMap> selectExcelAttd(Map<String, Object> params) {
		 String yearMonth = (String) params.get("calMonthYear");
		 String year = yearMonth.substring(0, 4);
		 String month = yearMonth.substring(4);
		 params.put("d", month + "/" + year);
		 return attendanceMapper.selectExcelAttd(params);
	 }

	 @Override
	 public String getMemCode(Map<String, Object> params) {
		 return attendanceMapper.getMemCode(params);
	 }

	 @Override
	 public List<EgovMap> selectHPReporting(Map<String, Object> p) {
		 return attendanceMapper.selectHPReporting(p);
	 }

	 @Override
	 public List<EgovMap> getReportingBranch() {
		 return attendanceMapper.getReportingBranch();
	 }
}
