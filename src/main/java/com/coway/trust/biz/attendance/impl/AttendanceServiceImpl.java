package com.coway.trust.biz.attendance.impl;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
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
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.attendance.AttendanceService;
import com.coway.trust.biz.payment.payment.service.ClaimResultUploadVO;
import com.coway.trust.biz.sample.impl.SampleServiceImpl;
import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.CommonUtils;
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
								data.put("attendTypeDesc", "Upload from batch " + params.get("batchId"));
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
	 public int checkIfHp(Map<String, Object> p) {
		 return attendanceMapper.checkIfHp(p);
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

	 private Object nvl(Object a, Object b) {
		return a != null ? a : b;
	 }

	 @Override
	 public String getAttendanceRaw(Map<String, Object> params) throws ParseException {
		 List<Map<String, Object>> returnData = new ArrayList();
	 	if ((new SimpleDateFormat("dd/MM/yyyy").parse(this.atdMigrateMonth())).after(new SimpleDateFormat("yyyyMM").parse((String) params.get("calMonthYear")))) {
	 		returnData.addAll(new Gson().fromJson((new Gson().toJson(this.selectExcelAttd(params))), new TypeToken<List<Map>>() {}.getType()));
		} else {
			List<EgovMap> memberInfo = new ArrayList();
			if (params.containsKey("memCode") && params.get("memCode").equals("ALL")) {
				EgovMap temp = new EgovMap();
				temp.put("memCode", "ALL");
				memberInfo.add(temp);
			} else {
				memberInfo = this.getMemberInfo(params);
			}
			memberInfo.stream().forEach((m) -> {
				try {
					URLConnection connection = new URL("https://epapanapis.malaysia.coway.do/apps/api/calendar/attendEvents/" + m.get("memCode") + "/reqDate/" + params.get("calMonthYear")).openConnection();
					connection.setRequestProperty("Authorization", epapanAuth);
					BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
					String input;
					StringBuffer content = new StringBuffer();
					while ((input = in.readLine()) != null) {
						content.append(input);
					}
					in.close();
					Map<String, Object> res = (Map<String, Object>) new Gson().fromJson(content.toString(), new TypeToken<Map<String, Object>>() {}.getType());
					List<Map<String, Object>> data = (List<Map<String, Object>>) nvl(res.get("dataList"), new ArrayList());
					if (params.get("memCode") != null && params.get("memCode").equals("ALL")) {
						List<String> members = new ArrayList();
						data.forEach((d) -> {
							if (!members.contains(d.get("name"))) {
								members.add((String) d.get("name"));
							}
						});
						int loop = members.size() / 999;
						if ((members.size() % 999) > 0) {
							loop += 1;
						}
						for (int i = 0; i < loop; i++) {
							int limit = i * 999 + 999;
							if (limit >= members.size()) {
								limit = members.size();
							}
							params.put("members", members.subList(i * 999, limit));
							List<EgovMap> membersInfo = this.getMemberInfo(params);
							returnData.addAll(data.stream().map((n) -> {
								EgovMap member = membersInfo.stream().filter((x) -> {
									return x.get("memCode").equals(n.get("name"));
								}).findFirst().orElseGet(() -> {return null;});
								if (member != null) {
									n.put("orgCode", member.get("orgCode"));
									n.put("grpCode", member.get("grpCode"));
									n.put("deptCode", member.get("deptCode"));
									n.put("hpType", member.get("hpType"));
									n.put("memCode", member.get("memCode"));
									n.put("memLvl", member.get("memLvl"));
								}
								return n;
							}).collect(Collectors.toList()));
						}
					} else {
						returnData.addAll(data.stream().map((n) -> {
							n.put("orgCode", m.get("orgCode"));
							n.put("grpCode", m.get("grpCode"));
							n.put("deptCode", m.get("deptCode"));
							n.put("hpType", m.get("hpType"));
							n.put("memCode", m.get("memCode"));
							n.put("memLvl", m.get("memLvl"));
							return n;
						}).collect(Collectors.toList()));
					}
				} catch (Exception e) {
					LOGGER.debug("############### {}", e);
					LOGGER.debug("Doesn't seem like will hit due to api accepting almost any argument.");
				}
			});
		}
	 	return new Gson().toJson(returnData.stream().map((d) -> {
	 		Map<String, Object> f = new HashMap();
	 		String date = null;
	 		String time = null;
	 		if (d.get("start").toString().contains("T")) {
	 			date = d.get("start").toString().split("T")[0];
	 			time = d.get("start").toString().split("T")[1];
	 		} else {
	 			date = d.get("start").toString().split(" ")[0];
	 			time = d.get("start").toString().split(" ")[1];
	 		}
	 		String type = d.get("attend_type_code") != null ? (String) d.get("attend_type_code") : (String) d.get("attendTypeCode");
	 		try {
	 			if (d.get("start").toString().contains("T")) {
		 			f.put("date", new SimpleDateFormat("yyyy/MM/dd").format(new SimpleDateFormat("yyyy-MM-dd").parse(date)));
		 			f.put("day", new SimpleDateFormat("EE").format(new SimpleDateFormat("yyyy-MM-dd").parse(date)).toUpperCase());
		 		} else {
		 			f.put("date", date);
		 			f.put("day", new SimpleDateFormat("EE").format(new SimpleDateFormat("yyyy/MM/dd").parse(date)).toUpperCase());
		 		}
	 			f.put("time", time);
	 			f.put("orgCode", d.get("orgCode"));
	 			f.put("grpCode", d.get("grpCode"));
	 			f.put("deptCode", d.get("deptCode"));
	 			f.put("hpCode", d.get("memCode"));
	 			f.put("hpType", d.get("hpType"));
	 			f.put("QR - A0001", type.equals("A0001") ? 1 : "");
	 			f.put("Public Holiday - A0002", type.equals("A0002") ? 1 : "");
	 			f.put("State Holiday - A0003", type.equals("A0003") ? 1 : "");
	 			f.put("RFA - A0004", type.equals("A0004") ? 1 : "");
	 			f.put("Waived - A0005", type.equals("A0005") ? 1 : "");
	 			int memLvl = 0;
	 			if (d.get("memLvl") != null) {
	 				if (d.get("start").toString().contains("T")) {
	 					memLvl = ((BigDecimal) d.get("memLvl")).intValue();
	 				} else {
	 					memLvl = ((Double) d.get("memLvl")).intValue();
	 				}
	 			}
	 			f.put("late", type.equals("A0001") ? (
	 					memLvl == 0 ? 0 :
	 						memLvl < 4 ? new SimpleDateFormat("HH:mm:ss").parse(time).after(new SimpleDateFormat("HH:mm:ss").parse("09:00:01")) ? 1 : 0 : new SimpleDateFormat("HH:mm:ss").parse(time).after(new SimpleDateFormat("HH:mm:ss").parse("11:00:01")) ? 1 : 0
	 					) : 0);
	 		} catch (Exception e) {
	 			LOGGER.debug("################# {}", CommonUtils.printStackTraceToString(e));
	 		}
	 		return f;
	 	}).collect(Collectors.toList()));
	 }
}
