package com.coway.trust.util;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Type;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.net.URLDecoder;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.Locale;
import java.util.Map;
import java.util.Random;
import java.util.SimpleTimeZone;
import java.util.StringTokenizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.FastDateFormat;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.expression.ParseException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.coway.trust.AppConstants;
import com.coway.trust.web.sales.SalesConstants;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.reflect.TypeToken;

/**
 * <pre>
 * 서비스 요청 데이타를 처리함에 있어 공통적으로 처리 될 수 있는 유틸리티성 기능들을 제공하는 클래스
 * </pre>
 */
@Service
public final class CommonUtils {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommonUtils.class);
	private static final String CHAR_LOWER = "abcdefghijklmnopqrstuvwxyz";
  private static final String CHAR_UPPER = CHAR_LOWER.toUpperCase();
  private static final String NUMBER = "0123456789";
  private static final String DATA_FOR_RANDOM_STRING = CHAR_LOWER+CHAR_UPPER+NUMBER;
  private static SecureRandom random = new SecureRandom();

  private Pattern pattern = Pattern.compile("-?\\d+(\\.\\d+)?");
  public static final Pattern VALID_EMAIL_ADDRESS_REGEX = Pattern.compile("^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,6}$",
      Pattern.CASE_INSENSITIVE);

  /** Whitespace regular expression. */
  private static final String WHITESPACE_REGEX = "\\s";
  /** Base64 validation regular expression. */
  private static final Pattern BASE64_PATTERN = Pattern.compile("^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)?$");
  private static final String PASSWORD_REGEX = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,15}$";


	private CommonUtils() {
	}

	/**
	 * <pre>
	 * Description  : null 처리 및 trim 처리를 한다.
	 * &#64;param strTemp
	 * </pre>
	 */
	public static int intNvl(Object objTemp) {
		return intNvl(String.valueOf(objTemp));
	}

	/**
	 * <pre>
	 * Description  : null 처리 및 trim 처리를 한다.
	 * &#64;param strTemp
	 * </pre>
	 */
	public static int intNvl(String objTemp) {
		int rtnValue;

		try {
			rtnValue = Integer.parseInt(nvl(objTemp));

		} catch (NumberFormatException ex) {
			rtnValue = 0;
		}

		return rtnValue;
	}

	public static long nvl(String str, long nullvalue) {
		if ((str == null) || (str == "") || (str.equals("null")) || (str.length() == 0)) {
			return nullvalue;
		} else {
			return Long.parseLong(str);
		}
	}

	/**
	 * <pre>
	 * Description  : null 처리 및 trim 처리를 한다.
	 * &#64;param strTemp
	 * </pre>
	 */
	public static String nvl(Object objTemp) {
		return nvl(String.valueOf(objTemp));
	}

	/**
	 * <pre>
	 * Description  : null 처리 및 trim 처리를 한다.
	 * &#64;param strTemp
	 * </pre>
	 */
	public static String nvl(String strTemp) {
		String rtnValue = "";

		if (strTemp == null)
			return "";

		if (strTemp.equals("undefined"))
			return "";

		if (strTemp.equals("null"))
			return "";

		if (strTemp.equals("")) {
			rtnValue = "";
		} else {
			rtnValue = strTemp.trim();
		}

		return rtnValue;
	}

	/**
	 * <pre>
	 * Description  : null 처리 및 trim 처리를 한다.
	 * </pre>
	 */
	public static String nvl2(String strTemp, String rtnVal) {
		if (strTemp == null || strTemp.equals("undefined") || strTemp.equals("null") || strTemp.equals("")) {
			return nvl(rtnVal);
		} else {
			return strTemp.trim();
		}
	}

	/**
	 * <pre>
	 * Description  : null 처리 및 trim 처리를 한다.
	 * </pre>
	 */
	public static String nvl2(Object objTemp, String rtnVal) {
		if (objTemp == null || objTemp.equals("undefined") || objTemp.equals("null") || objTemp.equals("")) {
			return nvl(rtnVal);
		} else {
			return nvl(objTemp);
		}
	}

	/**
	 * <pre>
	 * Description  : 현재 날짜를 가져온다.
	 * </pre>
	 */
	public static String getNowDate() {
		String rtnValue = "";

		Date date = new Date();
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd", Locale.getDefault(Locale.Category.FORMAT));
		rtnValue = df.format(date);

		return rtnValue;
	}


	/**
	 * <pre>
	 * Description  : 현재 날짜를 가져온다.
	 * </pre>
	 */
	public static String getDateToFormat(String format) {
		String dfFormat = nvl2(format, "yyyyMMdd");

		Date date = new Date();
		SimpleDateFormat df = new SimpleDateFormat(dfFormat, Locale.getDefault(Locale.Category.FORMAT));

		return df.format(date);
	}

	/**
	 * <pre>
	 * Description  : 오늘 날짜에서 +- d 값을 계산하여 날짜 값으로 리턴한다.
	 * &#64;param d
	 * </pre>
	 */
	public static String getCalDate(int d) {
		String rtnValue = "";

		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.DAY_OF_MONTH, d);
		Date date = calendar.getTime();

		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd", Locale.getDefault(Locale.Category.FORMAT));
		rtnValue = df.format(date);

		return rtnValue;
	}

	/**
	 * @param number of Day, format
	 * @author HQIT-HUIDING
	 * Jul 14, 2023
	 */
	public static String getCalDate(int d, String format) {
		String rtnValue = "";

		String dfFormat = nvl2(format, "yyyyMMdd");

		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.DAY_OF_MONTH, d);
		Date date = calendar.getTime();

		SimpleDateFormat df = new SimpleDateFormat(dfFormat, Locale.getDefault(Locale.Category.FORMAT));
		rtnValue = df.format(date);

		return rtnValue;
	}

	public static String getCalMonth(int d) {
		String rtnValue = "";

		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.MONTH, d);
		Date date = calendar.getTime();

		SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd", Locale.getDefault(Locale.Category.FORMAT));
		rtnValue = df.format(date);

		return rtnValue;
	}

	/**
	 * <pre>
	 * Description  : 특정 날짜에서 +-된 날짜를 반환한다.
	 * </pre>
	 *
	 * inputDate : 기준일자 d : 기준일자에서 +-될 일수 format : 기준일자와 반환일자 format
	 *
	 * @throws java.text.ParseException
	 */
	public static String getAddDay(String inputDate, int d, String format) throws java.text.ParseException {

		SimpleDateFormat df = new SimpleDateFormat(format, Locale.getDefault(Locale.Category.FORMAT));
		Date date = df.parse(inputDate);

		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.add(Calendar.DATE, d);

		return df.format(calendar.getTime());
	}

	/**
	 * <pre>
	 * Description  : 특정 날짜에서 +-된 날짜를 반환한다.
	 * </pre>
	 *
	 * inputDate : 기준일자 d : 기준일자에서 +-될 일수 format : 기준일자와 반환일자 format
	 *
	 * @throws java.text.ParseException
	 */
	public static String getAddMonth(String inputDate, int m, String format) throws java.text.ParseException {

		SimpleDateFormat df = new SimpleDateFormat(format, Locale.getDefault(Locale.Category.FORMAT));
		Date date = df.parse(inputDate);

		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.add(Calendar.MONTH, m);

		return df.format(calendar.getTime());
	}

	/**
	 * <pre>
	 * Description  : 현재 시간을 가져온다.
	 * </pre>
	 */
	public static String getNowTime() {
		String rtnValue = "";

		Date date = new Date();
		SimpleDateFormat df = new SimpleDateFormat("HHmmss", Locale.getDefault(Locale.Category.FORMAT));
		rtnValue = df.format(date);

		return rtnValue;
	}

	/**
	 * 타임포멧 : yyyyMMddHHmmssSSS
	 *
	 * @return
	 */
	public static String getMillisecondTime() {
		String rtnValue = "";

		Date date = new Date();
		SimpleDateFormat df = new SimpleDateFormat("yyyyMMddHHmmssSSS", Locale.getDefault(Locale.Category.FORMAT));
		rtnValue = df.format(date);

		return rtnValue;
	}

	// 문자열 앞에 특정한 문자를 채워서 리턴한다.
	public static String getFillString(Object objTemp, String fillString, int len) {
		return getFillString(String.valueOf(objTemp), fillString, len, null);
	}

	// 문자열 앞에 특정한 문자를 채워서 리턴한다.
	public static String getFillString(Object objTemp, String fillString, int len, String option) {
		return getFillString(String.valueOf(objTemp), fillString, len, option);
	}

	// 문자열 앞에 특정한 문자를 채워서 리턴한다.
	public static String getFillString(String strTemp, String fillString, int len) {
		return getFillString(strTemp, fillString, len, null);
	}

	// 문자열 앞에 특정한 문자를 채워서 리턴한다.
	public static String getFillString(int intTemp, String fillString, int len) {
		String strTemp = String.valueOf(intTemp);
		return getFillString(strTemp, fillString, len, null);
	}

	// 문자열 앞에 특정한 문자를 채워서 리턴한다.
	public static String getFillString(String strTemp, String fillString, int len, String option) {

		String pStrTemp = strTemp;
		String pOption = option;

		if (pStrTemp == null)
			return "";

		if (pStrTemp.length() >= len)
			return pStrTemp;

		// 데이터 String 이 null 인 경우 공백 처리
		if (pStrTemp.equals("null"))
			pStrTemp = "";

		if (pOption == null)
			pOption = "RIGHT";

		pOption = pOption.toUpperCase();
		StringBuilder rtnValue = new StringBuilder();

		if (pOption.equals("RIGHT")) {
			// 앞에 문자열을 채워서 리턴한다.
			int pLen = len - pStrTemp.length();
			for (int i = 0; i < pLen; i++) {
				rtnValue.append(fillString);
			}
			rtnValue.append(pStrTemp);
		} else {
			// 뒤에 문자열을 채워서 리턴한다.
			rtnValue.append(pStrTemp);
			for (int i = pStrTemp.length(); i < len; i++) {
				rtnValue.append(fillString);
			}
		}

		return rtnValue.toString();
	}

	// 숫자에 천단위로 콤마를 찍는다.
	public static String getNumberFormat(double number) {
		return getNumberFormat(String.valueOf(number));
	}

	// 숫자에 천단위로 콤마를 찍는다.
	public static String getNumberFormat(int number) {
		return getNumberFormat(String.valueOf(number));
	}

	// 숫자에 천단위로 콤마를 찍는다.
	public static String getNumberFormat(double number, String format) {
		return getNumberFormat(String.valueOf(number), format);
	}

	// 숫자에 천단위로 콤마를 찍는다.
	public static String getNumberFormat(int number, String format) {
		return getNumberFormat(String.valueOf(number), format);
	}

	// 숫자에 천단위로 콤마를 찍는다.
	public static String getNumberFormat(String number) {
		return getNumberFormat(String.valueOf(number), "#,##0");
	}

	// 숫자에 천단위로 콤마를 찍는다.
	public static String getNumberFormat(String number, String format) {
		String rtnValue = "";
		double num = 0;

		if (number == null)
			return rtnValue;

		String trimNumber = number.trim();
		if (trimNumber.equals(""))
			num = 0;
		else
			num = Double.parseDouble(trimNumber);

		DecimalFormat df = new DecimalFormat(format);
		rtnValue = df.format(num);

		return rtnValue;
	}

	public static String maxDayBefore(int cnt) {

		Calendar cals = Calendar.getInstance();
		cals.add(Calendar.DATE, cnt);

		int tmpDays = cals.get(Calendar.DATE);
		int tmpMonths = cals.get(Calendar.MONTH) + 1;
		String years = String.valueOf(cals.get(Calendar.YEAR));
		String days = "";
		String months = "";

		if (tmpDays >= 1 && tmpDays < 10)
			days = "0" + tmpDays;
		else
			days = String.valueOf(tmpDays);

		if (tmpMonths >= 1 && tmpMonths < 10)
			months = "0" + tmpMonths;
		else
			months = String.valueOf(tmpMonths);

		return years + months + days;
	}

	public String getDateNormal() {
		StringBuffer sb = new StringBuffer();
		Calendar cal;
		cal = Calendar.getInstance(new SimpleTimeZone(9 * 60 * 60 * 1000, "KST"));

		sb = sb.append(cal.get(Calendar.YEAR));
		sb = sb.append("-");
		sb = sb.append(reformat(cal.get(Calendar.MONTH) + 1));
		sb = sb.append("-");
		sb = sb.append(reformat(cal.get(Calendar.DATE)));
		return sb.toString();
	}

	private String reformat(int n) {
		StringBuilder sb = new StringBuilder(2);

		if (n < 10) {
			sb.append("0").append(n);
		} else {
			sb.append(String.valueOf(n));
		}
		return sb.toString();
	}

	/**
	 * String을 받아서 숫자인지 판단후 리턴한다.
	 *
	 * @param str
	 * @return boolean
	 * @auth Na Seung Bok
	 */
	public static boolean isNumCheck(String str) throws Exception {
		boolean result = true;
		try {
			if (str == null || str.equals("")) {
				result = false;
			} else {
				for (int index = 0; index < str.length(); index++) {
					if (!java.lang.Character.isDigit(str.charAt(index))) {
						result = false;
						break;
					}
				}
			}
		} catch (Exception e) {
			throw e;
		}
		return result;
	}

	public static String getMile(double w) {
		java.text.DecimalFormat df = new java.text.DecimalFormat("###,##0.0");
		return df.format(w);
	}

	/**
	 * <pre>
	 * 날짜 문자열을 다른 포맷의 날짜 문자열로 변환.
	 * ex) changeFormat("20081220","yyyyMMdd","yyyy-MM-dd"); -->결과: 2008-12-20
	 * </pre>
	 *
	 * @param source
	 *            대상 날짜 문자열
	 * @param sourcePattern
	 *            원래 날짜 포맷
	 * @param targetPattern
	 *            변환할 날짜 포맷
	 * @return 변환된 문자열
	 */
	public static String changeFormat(String source, String sourcePattern, String targetPattern) {

		SimpleDateFormat sdf1 = new SimpleDateFormat(sourcePattern, java.util.Locale.KOREA);
		SimpleDateFormat sdf2 = new SimpleDateFormat(targetPattern, java.util.Locale.KOREA);

		String result = "";

		try {
			java.util.Date date = sdf1.parse(source);
			result = sdf2.format(date);
		} catch (Exception e) {
			result = source;
		}
		return result;
	}

	public static String printStackTraceToString(Exception ex) {
		StringWriter errors = new StringWriter();

		try {
			ex.printStackTrace(new PrintWriter(errors));
		} catch (Exception e) {
			LOGGER.warn("ignore");
		}
		return errors.toString();
	}

	/**
	 * value 가 null 또는 empty 인지 체크 한다.
	 *
	 * @param value
	 * @return empty 여부
	 */
	public static boolean isEmpty(String value) {
		return StringUtils.isEmpty(value);
	}

	/**
	 * value 가 null 또는 empty 인지 체크 한다.
	 *
	 * @param value
	 * @return empty 여부
	 */
	public static boolean isEmpty(Object value) {
		if (value == null) {
			return true;
		}
		if (value instanceof String) {
			return StringUtils.isEmpty((String) value);
		} else if (value instanceof String[]) {
			String[] values = (String[]) value;
			return (values.length < 1);
		} else if (value instanceof Collection<?>) {
			if (((Collection<?>) value).size() < 1) {
				return true;
			}
		}
		return false;
	}

	/**
	 * values 배열 요소에 null 또는 empty 값이 있는지 여부를 체크 한다.
	 *
	 * @param values
	 * @return
	 */
	public static boolean containsEmpty(String... values) {
		if (values == null) {
			return true;
		}
		for (String value : values) {
			if (value == null || StringUtils.isEmpty(value)) {
				return true;
			}
		}
		return false;
	}

	/**
	 * value 값이 없다면 defaultValue 값을 리턴 한다.
	 *
	 * @param value
	 * @param defaultValue
	 * @return
	 */
	public static String nvl(String value, String defaultValue) {
		if (value != null) {
			return value;
		} else {
			return defaultValue;
		}
	}

	/**
	 * value 값이 없다면 defaultValue 값을 리턴 한다.
	 *
	 * @param value
	 * @param defaultValue
	 * @return
	 */
	public static Integer nvl(Integer value, Integer defaultValue) {
		if (value != null) {
			return value;
		} else {
			return defaultValue;
		}
	}

	/**
	 * Object가 Null이 아니거나 Empty가 아닌지 확인한다.
	 *
	 * @param value
	 * @return empty가 아닌 경우 true, empty인 경우 false 반환
	 */
	public static boolean isNotEmpty(Object value) {
		return !isEmpty(value);
	}

	/**
	 * value 파라미터 값을 integer 객체의 값으로 변환한 값을 리턴
	 *
	 * @param value
	 *            소스 객체 값
	 * @return integer 형 변환 객체 값
	 */
	public static Integer getInteger(Object value) {
		if (value == null) {
			return null;
		}
		if (value instanceof Integer) {
			return (Integer) value;
		}
		if (value instanceof String) {
			return Integer.valueOf((String) value);
		} else if (value instanceof BigDecimal) {
			return ((BigDecimal) value).intValue();
		} else if (value instanceof BigInteger) {
			return ((BigInteger) value).intValue();
		} else if (value instanceof Long) {
			return ((Long) value).intValue();
		}
		return (Integer) value;
	}

	public static int getInt(Object value) {
		if (value == null) {
			return 0;
		}
		return getInteger(value);
	}

	/**
	 * value 파라미터 값을 Long 객체의 값으로 변환한 값을 리턴
	 *
	 * @param value
	 *            소스 객체 값
	 * @return Long 형 변환 객체 값
	 */
	public static Long getLong(Object value) {
		if (value == null) {
			return null;
		}
		if (value instanceof Integer) {
			return ((Number) value).longValue();
		} else if (value instanceof BigDecimal) {
			return ((BigDecimal) value).longValue();
		} else if (value instanceof BigInteger) {
			return ((BigInteger) value).longValue();
		} else if (value instanceof Long) {
			return (Long) value;
		}
		return (Long) value;
	}

	/**
	 * 날짜 포멧에 해당하는 문자열 값을 리턴
	 *
	 * @param format
	 *            날짜 포멧
	 * @return 포메팅된 값
	 */
	public static String getFormattedString(String format) {
		return FastDateFormat.getInstance(format).format(Calendar.getInstance());
	}

	/**
	 * 날짜 포멧에 해당하는 문자열 값을 리턴
	 *
	 * @param format
	 *            날짜 포멧
	 * @param date
	 *            기준 시간
	 * @return 포메팅된 값
	 */
	public static String getFormattedString(final String format, final Date date) {
		return FastDateFormat.getInstance(format).format(date);
	}

	/**
	 * Boolean 속성들에 대해 데이타 타입을 재 설정 해 준다.
	 *
	 * @param params
	 *            파라미터 맵
	 * @param properties
	 *            boolean 타입 속성 명
	 */
	public static void rebindBooleanProperties(Map<String, Object> params, String... properties) {
		for (String prop : properties) {
			String value = (String) params.get(prop);
			if ("true".equals(value) || "false".equals(value)) {
				params.put(prop, Boolean.valueOf(value));
			}
		}
	}

	/**
	 * Boolean 속성들에 대해 데이타 타입을 재 설정 해 준다.
	 *
	 * @param params
	 *            파라미터 맵
	 */
	public static void rebindBooleanProperties(Map<String, Object> params) {
		if (params != null) {
			for (Map.Entry<String, Object> p : params.entrySet()) {
				String name = p.getKey();
				if (name.endsWith("_yn")) {
					String value = (String) p.getValue();
					if ("true".equals(value) || "false".equals(value)) {
						params.put(name, Boolean.valueOf(value));
					}
				}
			}
		}
	}

	/**
	 * @param value
	 * @return delimiterValues
	 */
	public static String[] getDelimiterValues(final String value) {
		if (value == null) {
			return new String[] { "0" };
		}
		StringTokenizer token = new StringTokenizer(value, AppConstants.DEFAULT_DELIMITER);
		LinkedList<String> set = new LinkedList<>();
		while (token.hasMoreTokens()) {
			set.add(token.nextToken());
		}
		if (set.size() < 1) {
			return new String[] { value };
		}
		String[] arrays = set.toArray(new String[set.size()]);
		return arrays;
	}

	private static final String[] CONTROL_CHARS = { "\n", "\t", "\r\n" };

	/**
	 * 구분자로 연결된 문자열을 리턴 한다.
	 *
	 * @param words
	 * @return
	 */
	public static String concatDelimiterWords(Collection<String> words) {
		if (words == null || words.size() < 1) {
			return null;
		}
		StringBuilder builder = new StringBuilder();
		for (String word : words) {
			word = word.trim();
			if (StringUtils.isEmpty(word)) {
				continue;
			}
			for (String ctrChar : CONTROL_CHARS) {
				if (word.contains(ctrChar)) {
					word = word.replaceAll(ctrChar, "");
				}
			}
			builder.append(word).append(AppConstants.DEFAULT_DELIMITER);
		}
		int length = builder.length();
		builder.delete(length - 3, length);
		return builder.toString();
	}

	/**
	 * <pre>
	 * validator.validate(message, errors);
	 * //Check validation errors
	 * if (result.hasErrors()) {
	 *    // throws CommonUtils.throwNotValidException( errors );
	 *    throws throwNotValidException( errors );
	 * }
	 * </pre>
	 *
	 * @param errors
	 * @return
	 */
	public static MethodArgumentNotValidException throwNotValidException(BindingResult errors) {
		return new MethodArgumentNotValidException(null, errors);
	}

	/**
	 * List<String> 값을 "key1, key2, key3, ..." 으로 변환
	 *
	 * @param values
	 * @return
	 */
	public static String toCommaDelimitedString(String... values) {
		if (values == null) {
			return null;
		}
		StringBuilder builder = new StringBuilder();
		int index = 0;
		for (String val : values) {
			if (index == 0) {
				builder.append(val);
			} else {
				builder.append(", ").append(val);
			}
			++index;
		}
		return builder.toString();
	}

	public static boolean getBoolean(Object val) {
		if (val == null) {
			return false;
		}
		if (val instanceof Boolean) {
			return (Boolean) val;
		} else if (val instanceof String) {
			String sval = (String) val;
			if ("1".equals(sval) || "true".equalsIgnoreCase(sval)) {
				return true;
			}
		} else if (val instanceof Integer) {
			if ((Integer) val < 1) {
				return false;
			}
			return true;
		} else if (val instanceof Long) {
			if (((Long) val).intValue() < 1) {
				return false;
			}
			return true;
		} else if (val instanceof BigDecimal) {
			if (((BigDecimal) val).intValue() < 1) {
				return false;
			}
			return true;
		} else if (val instanceof BigInteger) {
			if (((BigInteger) val).intValue() < 1) {
				return false;
			}
			return true;
		}
		return false;
	}

	public static boolean isTrue(Object val) {
		if (val == null) {
			return false;
		}
		if (val instanceof Boolean) {
			return (Boolean) val;
		} else if (val instanceof String) {
			String sval = (String) val;
			if ("1".equals(sval) || "true".equalsIgnoreCase(sval)) {
				return true;
			}
		} else if (val instanceof Integer) {
			if ((Integer) val == 1) {
				return true;
			}
		}
		return false;
	}

	public static long getDiffDate(String cutOffDate) {
		return getDiffDate(cutOffDate, "yyyyMMdd");
	}

	public static long getDiffDate(String cutOffDate, String format) {
		long diffDate = -1;

		try {
			SimpleDateFormat formatter = new SimpleDateFormat(format, Locale.getDefault(Locale.Category.FORMAT));
			Date cutoffdate = formatter.parse(cutOffDate);
			Date curDate = new Date();

			long diff = curDate.getTime() - cutoffdate.getTime();
			diffDate = diff / (24 * 60 * 60 * 1000);

		} catch (ParseException | java.text.ParseException e) {
			e.printStackTrace();
		}

		return diffDate;
	}

	public static long getDiffDate(String criteriaDate, String cutOffDate, String format) {
		long diffDate = -1;

		try {
			SimpleDateFormat formatter = new SimpleDateFormat(format, Locale.getDefault(Locale.Category.FORMAT));
			Date cutoffdate = formatter.parse(cutOffDate);
			Date curDate = formatter.parse(criteriaDate);

			long diff = curDate.getTime() - cutoffdate.getTime();
			diffDate = diff / (24 * 60 * 60 * 1000);

		} catch (ParseException | java.text.ParseException e) {
			e.printStackTrace();
		}

		return diffDate;
	}

	public static String getMaskCreditCardNo(String inputStr, String maskStr, int visibleDigit) {
		String retVal = null;
		if (CommonUtils.isEmpty(inputStr)) {
			retVal = inputStr;
		} else {
			retVal = StringUtils.repeat(maskStr, inputStr.length() - visibleDigit)
					+ inputStr.substring(inputStr.length() - visibleDigit);
		}
		return retVal;
	}

	/**
	 * 입력받은 문자열을 입력받은 크기만큼 왼쪽에서 부터 substring 일반적인 substring 과 동일함.
	 *
	 * @param inputStr
	 * @param len
	 * @return
	 */
	public static String left(String inputStr, int len) {
		String retVal = null;

		if (inputStr.length() < 1) {
			retVal = "";
		} else {
			retVal = inputStr.substring(0, len);
		}
		return retVal;
	}

	/**
	 * 입력받은 문자열을 입력받은 크기만큼 오른쪽에서 substring
	 *
	 * @param inputStr
	 * @param len
	 * @return
	 */
	public static String right(String inputStr, int len) {
		String retVal = null;

		if (inputStr.length() < 1) {
			retVal = "";
		} else {
			int startIdx = inputStr.length() - len < 1 ? 0 : inputStr.length() - len;
			retVal = inputStr.substring(startIdx, inputStr.length());
		}
		return retVal;
	}

	public static String formatFileSize(long size) {
		if (size <= 0)
			return "0";
		final String[] units = new String[] { "B", "kB", "MB", "GB", "TB" };
		int digitGroups = (int) (Math.log10(size) / Math.log10(1024));
		return new DecimalFormat("#,##0.#").format(size / Math.pow(1024, digitGroups)) + " " + units[digitGroups];
	}

	public static <T> T getBean(String beanName, Class<T> type) {
		// 현재 요청중인 thread local의 HttpServletRequest 객체 가져오기
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes())
				.getRequest();

		// HttpSession 객체 가져오기
		HttpSession session = request.getSession();

		// ServletContext 객체 가져오기
		ServletContext conext = session.getServletContext();

		// Spring Context 가져오기
		WebApplicationContext wContext = WebApplicationContextUtils.getWebApplicationContext(conext);

		return (T) wContext.getBean(beanName);
	}

	/**
	 * AS-IS : CommonFunction.cs - GetRandomNumber 변환 method
	 *
	 * @param size
	 * @return
	 */
	public static String getRandomNumber(int size) {
		Random random = new Random();
		char[] chars = "abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ".toCharArray();

		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < size; i++) {
			int num = random.nextInt(chars.length);
			sb.append(chars[num]);
		}
		return sb.toString();
	}

	public static String getClientIp(final HttpServletRequest request) {
		String clientIp = request.getHeader("X-Forwarded-For");

		if (clientIp == null || clientIp.length() == 0 || "unknown".equalsIgnoreCase(clientIp)) {
			clientIp = request.getHeader("Proxy-Client-IP");
		}
		if (clientIp == null || clientIp.length() == 0 || "unknown".equalsIgnoreCase(clientIp)) {
			clientIp = request.getHeader("WL-Proxy-Client-IP");
		}
		if (clientIp == null || clientIp.length() == 0 || "unknown".equalsIgnoreCase(clientIp)) {
			clientIp = request.getHeader("HTTP_CLIENT_IP");
		}
		if (clientIp == null || clientIp.length() == 0 || "unknown".equalsIgnoreCase(clientIp)) {
			clientIp = request.getHeader("HTTP_X_FORWARDED_FOR");
		}
		if (clientIp == null || clientIp.length() == 0 || "unknown".equalsIgnoreCase(clientIp)) {
			clientIp = request.getHeader("X-Real-IP");
		}
		if (clientIp == null || clientIp.length() == 0 || "unknown".equalsIgnoreCase(clientIp)) {
			clientIp = request.getHeader("X-RealIP");
		}
		if (clientIp == null || clientIp.length() == 0 || "unknown".equalsIgnoreCase(clientIp)) {
			clientIp = request.getRemoteAddr();
		}
		return clientIp;
	}

	/*
	 * 66 --> 2284 REN : Rental 67 --> 2285 OUT : Outright 68 --> 2286 INS : Installment 1412 --> 2287 OUTPLS: Outright
	 * Plus 1036 --> 2288 OSVM : Outright SVM(X) 1330 --> 2289 RSVM : Rental SVM(X) 1035 --> 2290 FIL : Expired
	 * Filter(X)
	 */
	public static int changePromoAppTypeId(int iAppTypeId) {
		int iPromoAppTypeId = 0;

		if (iAppTypeId == SalesConstants.APP_TYPE_CODE_ID_RENTAL) {
			iPromoAppTypeId = SalesConstants.PROMO_APP_TYPE_CODE_ID_REN;
		} else if (iAppTypeId == SalesConstants.APP_TYPE_CODE_ID_OUTRIGHT) {
			iPromoAppTypeId = SalesConstants.PROMO_APP_TYPE_CODE_ID_OUT;
		} else if (iAppTypeId == SalesConstants.APP_TYPE_CODE_ID_INSTALLMENT) {
			iPromoAppTypeId = SalesConstants.PROMO_APP_TYPE_CODE_ID_INS;
		} else if (iAppTypeId == SalesConstants.APP_TYPE_CODE_ID_OUTRIGHTPLUS) {
			iPromoAppTypeId = SalesConstants.PROMO_APP_TYPE_CODE_ID_OUTPLS;
		} else if (iAppTypeId == SalesConstants.PROMO_APP_TYPE_CODE_ID_REN) {
			iPromoAppTypeId = SalesConstants.APP_TYPE_CODE_ID_RENTAL;
		} else if (iAppTypeId == SalesConstants.PROMO_APP_TYPE_CODE_ID_OUT) {
			iPromoAppTypeId = SalesConstants.APP_TYPE_CODE_ID_OUTRIGHT;
		} else if (iAppTypeId == SalesConstants.PROMO_APP_TYPE_CODE_ID_INS) {
			iPromoAppTypeId = SalesConstants.APP_TYPE_CODE_ID_INSTALLMENT;
		} else if (iAppTypeId == SalesConstants.PROMO_APP_TYPE_CODE_ID_OUTPLS) {
			iPromoAppTypeId = SalesConstants.APP_TYPE_CODE_ID_OUTRIGHTPLUS;
		} else if (iAppTypeId == SalesConstants.APP_TYPE_CODE_ID_FREE_TRIAL ) {
			iPromoAppTypeId = SalesConstants.APP_TYPE_CODE_ID_FREE_TRIAL ;
		} else if (iAppTypeId == SalesConstants.APP_TYPE_CODE_ID_EDUCATION ) {
      iPromoAppTypeId = SalesConstants.PROMO_APP_TYPE_CODE_ID_EDU;
    }

		return iPromoAppTypeId;
	}

	/**
	 * 마지막 대상 문자열을 변경한다.
	 *
	 * @param string
	 * @param toReplace
	 * @param replacement
	 * @return
	 */
	public static String replaceLast(String string, String toReplace, String replacement) {
		int _lastIdx = string.lastIndexOf(toReplace);
		if (_lastIdx > -1) {
           return string.substring(0, _lastIdx)+ replacement + string.substring(_lastIdx +   toReplace.length(), string.length());
		} else {
			return string;
		}
	}

	/**
	 * 시간을 24시로 변환한다.
	 *
	 * @param strTm
	 * @return
	 */
	public static String convert24Tm(String strTm) {
		String cvtTm = "";

		if(isNotEmpty(strTm)) {
			String ampm = right(strTm, 2);
			String hour = left(strTm, 2);
			String min = strTm.substring(3, 5);

			if("PM".equals(ampm.toUpperCase())) {
				cvtTm = String.valueOf(Integer.parseInt(hour) + 12) + ":" + min + ":00";
			} else  {
				cvtTm = hour + ":" + min + ":00";
			}
		}
		return cvtTm;
	}

//From TH common Utils

  public static boolean isJSONValid(String test) {
      try {
          new JSONObject(test);
      } catch (JSONException ex) {
          // edited, to include @Arthur's comment
          // e.g. in case JSONArray is valid as well...
          try {
              new JSONArray(test);
          } catch (JSONException ex1) {
              return false;
          }
      }
      return true;
  }

  public static boolean isNullOrEmpty(String str) {
      if(str != null && !str.isEmpty())
          return false;
      return true;
  }
  public static String generalErrorReturnString(String errorType, String errorMsg, JsonObject jsonObject) {
    String returnJsonString = "";
    JsonObject returnJson = new JsonObject();
    returnJson.addProperty("oRtnCode","ERROR" );

    switch(errorType) {
      case "MISSINGKEY":
      returnJson.addProperty("oRtnMsg", "Mandatory Key in Json is missing: Key["+errorMsg+"]");
      break;
      case "UNKNOWNKEY":
      returnJson.addProperty("oRtnMsg", "Key Value in Json is unknown: Key["+errorMsg+"]");
      break;
      case "JSONERROR":
      returnJson.addProperty("oRtnMsg", "Body Contents Error: Body["+errorMsg+"]");
      break;
      case "INT-ERR":
      returnJson.addProperty("oRtnMsg", errorMsg);
      break;
      case "UNKNOWN":
      returnJson.addProperty("oRtnMsg", errorMsg);
      break;
      default:
      returnJson.addProperty("oRtnMsg", errorMsg);
    }

    returnJson.add("oRtnJson",jsonObject );
  returnJsonString = returnJson.toString();


    return returnJsonString;
  }

  public static String generalSuccessReturnString(JsonObject jsonObject) {
    String returnJsonString = "";
    JsonObject returnJson = new JsonObject();
    returnJson.addProperty("oRtnCode","OK" );
    returnJson.addProperty("oRtnMsg", "-");

    returnJson.add("oRtnJson",jsonObject );
  returnJsonString = returnJson.toString();


    return returnJsonString;
  }

  public static ResponseEntity<Object> httpReqRtnString(String code, Object Msg, JsonObject dataJsonObj, String errorType ) {
    HttpStatus rtnHttpStatus;

    switch(errorType) {
      case "br":
        rtnHttpStatus = HttpStatus.BAD_REQUEST;
        break;
      case "ok":
        rtnHttpStatus = HttpStatus.OK;
        break;
        default:
          rtnHttpStatus = HttpStatus.INTERNAL_SERVER_ERROR;
    }


    JsonObject returnJson = new JsonObject();
  String returnJsonString = "";

        returnJson.addProperty("oResultCd",code);
        returnJson.addProperty("oResultMsg",Msg.toString());
        returnJson.add("oResultData",dataJsonObj);
        returnJsonString = returnJson.toString();
  return new ResponseEntity<Object>(returnJsonString, rtnHttpStatus);

  }

  public static ResponseEntity<Object> httpReqRtnString(String code, Object Msg, JsonArray dataJsonArray, String errorType ) {
    HttpStatus rtnHttpStatus;

    switch(errorType) {
      case "br":
        rtnHttpStatus = HttpStatus.BAD_REQUEST;
        break;
      case "ok":
        rtnHttpStatus = HttpStatus.OK;
        break;
        default:
          rtnHttpStatus = HttpStatus.INTERNAL_SERVER_ERROR;
    }


    JsonObject returnJson = new JsonObject();
  String returnJsonString = "";

        returnJson.addProperty("oResultCd",code);
        returnJson.addProperty("oResultMsg",Msg.toString());
        returnJson.add("oResultData",dataJsonArray);
        returnJsonString = returnJson.toString();
  return new ResponseEntity<Object>(returnJsonString, rtnHttpStatus);

  }

  public static boolean isJSONArray(String test) {
      try {
          new JSONArray(test);
      } catch (JSONException ex) {

              return false;
      }
      return true;
  }

  public static boolean isJSONObject(String test) {
      try {
          new JSONObject(test);
      } catch (JSONException ex) {

              return false;
      }
      return true;
  }
  public static String returnMsgBuilderJsonArr(String rtnCode, String rtnMsg, JsonArray rtnJsonArr){

    JsonObject returnJson = new JsonObject();
    returnJson.addProperty("oRtnCode",rtnCode );
    returnJson.addProperty("oRtnMsg", rtnMsg);
    returnJson.add("oRtnJsonArr", rtnJsonArr );
  return returnJson.toString();
  }
  public static String returnMsgBuilderJsonObj(String rtnCode, String rtnMsg, JsonObject rtnJsonArr){

    JsonObject returnJson = new JsonObject();
    returnJson.addProperty("Result",rtnCode );
    returnJson.addProperty("ResultMsg", rtnMsg);
    returnJson.add("oRtnJsonArr", rtnJsonArr );
  return returnJson.toString();
  }

public static Map<String, Object> splitQueryString(String str) throws UnsupportedEncodingException {
    Map<String, Object> query_pairs = new LinkedHashMap<String, Object>();
    String[] pairs = str.split("&");

    for (String pair : pairs) {
        int idx = pair.indexOf("=");
        query_pairs.put(URLDecoder.decode(pair.substring(0, idx), "UTF-8"), URLDecoder.decode(pair.substring(idx + 1), "UTF-8"));
        LOGGER.info("splitQueryString.pair & Key:{}:{}",URLDecoder.decode(pair.substring(0, idx), "UTF-8"),URLDecoder.decode(pair.substring(idx + 1), "UTF-8"));
    }
    return query_pairs;
}


public static Map<String, Object> convertPostBodyToMap(String str) {
    Map<String, Object> query_pairs = new LinkedHashMap<String, Object>();
    Gson gson = new Gson();
    try {
        if(isJSONObject(str)) {

          Type type = new TypeToken<Map<String, Object>>(){}.getType();
          query_pairs = gson.fromJson(str, type);

        }else {

        query_pairs = splitQueryString(str);

        }

        return query_pairs;
    }catch (UnsupportedEncodingException e) {
    // TODO Auto-generated catch block
    e.printStackTrace();
    return query_pairs;
  }
}

  public static String generateRandomString(int length) {
      if (length < 1) throw new IllegalArgumentException();

      StringBuilder sb = new StringBuilder(length);
      for (int i = 0; i < length; i++) {

      // 0-62 (exclusive), random returns 0-61
          int rndCharAt = random.nextInt(DATA_FOR_RANDOM_STRING.length());
          char rndChar = DATA_FOR_RANDOM_STRING.charAt(rndCharAt);

          // debug

          sb.append(rndChar);

      }

      return sb.toString();

  }


public static JsonArray jsonArrAGridByType(String AuiGrid, String gridContentsType) {
      JsonObject  tmpJsonObj  = new JsonObject();
      JsonElement tmpJsonElem  = null;
      JsonArray rtnJsonArr  = new JsonArray();
      Gson gson = new Gson();
      try {
        String[] gridContentsTypes = {"add","update","remove","checked"};
        boolean contains = Arrays.stream(gridContentsTypes).anyMatch(gridContentsType::equals);

        if(!contains) {
          throw new Exception ("gridContentsType is not correct value:"+gridContentsType);
        }

        if(!isJSONObject(AuiGrid)) {
          throw new Exception ("AUIGrid Input is not JsonObject");
        }


        tmpJsonObj  = gson.fromJson(AuiGrid,JsonObject.class);

        if(!tmpJsonObj.has(gridContentsType)){
          throw new Exception ("No AUIGrid key ("+gridContentsType+")");
        }

        tmpJsonElem = tmpJsonObj.get(gridContentsType);
        if(!tmpJsonElem.isJsonArray()) {
          throw new Exception ("No AUIGrid key ("+gridContentsType+") is Not JsonArray");
        }
        rtnJsonArr = tmpJsonElem.getAsJsonArray();



          return rtnJsonArr;
      }catch (Exception e) {
      // TODO Auto-generated catch block
        LOGGER.error("Unexpected Exception on jsonArrAGridByType:"+e.getMessage());
      e.printStackTrace();
      return null;
    }
  }

public static boolean isInteger(String s) {
    return isInteger(s,10);
}

public static boolean isInteger(String s, int radix) {
    if(s.isEmpty()) return false;
    for(int i = 0; i < s.length(); i++) {
        if(i == 0 && s.charAt(i) == '-') {
            if(s.length() == 1) return false;
            else continue;
        }
        if(Character.digit(s.charAt(i),radix) < 0) return false;
    }
    return true;
}

  public static boolean isValidDate(String date, String DateFormat) {

      boolean valid = false;

      try {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern(DateFormat);
          // ResolverStyle.STRICT for 30, 31 days checking, and also leap year.
          LocalDate.parse(date,formatter);

          valid = true;

      } catch (DateTimeParseException e) {
          //e.printStackTrace();
        LOGGER.error("DateTimeParseException with Msg:{}",e.getMessage());
          valid = false;
      }

      return valid;
  }

  public static boolean isNumeric(String strNum) {
      if (strNum == null) {
          return false;
      }
      try {
          double d = Double.parseDouble(strNum);
      } catch (NumberFormatException nfe) {
          return false;
      }
      return true;
  }

  public static boolean isValidBase64(final String s) {
      final String sanitized = s.replaceAll(WHITESPACE_REGEX, "");
      return BASE64_PATTERN.matcher(sanitized).matches();
  }

  public static boolean isValidPassword(String password){
      Pattern pattern = Pattern.compile(PASSWORD_REGEX);
      Matcher matcher = pattern.matcher(password);
      return matcher.matches();
  }
}
