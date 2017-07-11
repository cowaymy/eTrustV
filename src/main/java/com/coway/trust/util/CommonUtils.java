package com.coway.trust.util;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.LinkedList;
import java.util.Map;
import java.util.SimpleTimeZone;
import java.util.StringTokenizer;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.FastDateFormat;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.MethodArgumentNotValidException;

import com.coway.trust.AppConstants;

/**
 * <pre>
 * 서비스 요청 데이타를 처리함에 있어 공통적으로 처리 될 수 있는 유틸리티성 기능들을 제공하는 클래스
 * </pre>
 *
 * @author aider
 */
public final class CommonUtils {

	private final static String URI_REGEX = "\\{[A-z0-9]*\\}";
	
	/**
     * <pre>
     * Description  : null 처리 및 trim 처리를 한다.
     * @param strTemp
     * </pre>
     */
    public static int intNvl( Object objTemp ){
        return intNvl(String.valueOf(objTemp));
    }

    /**
     * <pre>
     * Description  : null 처리 및 trim 처리를 한다.
     * @param strTemp
     * </pre>
     */
    public static int intNvl( String objTemp ){
        int rtnValue;

        try {
            rtnValue = Integer.parseInt(nvl(objTemp));

        } catch (NumberFormatException ex) {
            rtnValue = 0;
        }

        return rtnValue;
    }

    public static long nvl( String str, long nullvalue ){
        if ((str == null) || (str == "") || (str.equals("null")) || (str.length() == 0)) {
            return nullvalue;
        } else {
            return Long.parseLong(str);
        }
    }

    /**
     * <pre>
     * Description  : null 처리 및 trim 처리를 한다.
     * @param strTemp
     * </pre>
     */
    public static String nvl( Object objTemp ){
        return nvl(String.valueOf(objTemp));
    }

    /**
     * <pre>
     * Description  : null 처리 및 trim 처리를 한다.
     * @param strTemp
     * </pre>
     */
    public static String nvl( String strTemp ){
        String rtnValue = "";

        if (strTemp == null)
            return "";

        if (strTemp.equals("undefined"))
            return "";

        if (strTemp.equals("null"))
            return "";

        strTemp = strTemp.trim();

        if (strTemp.equals("")) {
            rtnValue = "";
        } else {
            rtnValue = strTemp;
        }

        return rtnValue;
    }

    /**
     * <pre>
     * Description  : 현재 날짜를 가져온다.
     * </pre>
     */
    public static String getNowDate(){
        String rtnValue = "";

        Date date = new Date();
        SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
        rtnValue = df.format(date);

        return rtnValue;
    }

    /**
     * <pre>
     * Description  : 오늘 날짜에서 +- d 값을 계산하여 날짜 값으로 리턴한다.
     * @param d
     * </pre>
     */
    public static String getCalDate( int d ){
        String rtnValue = "";

        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.DAY_OF_MONTH, d);
        Date date = calendar.getTime();

        SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
        rtnValue = df.format(date);

        return rtnValue;
    }

    public static String getCalMonth( int d ){
        String rtnValue = "";

        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.MONTH, d);
        Date date = calendar.getTime();

        SimpleDateFormat df = new SimpleDateFormat("yyyyMMdd");
        rtnValue = df.format(date);

        return rtnValue;
    }

    /**
     * <pre>
     * Description  : 현재 시간을 가져온다.
     * </pre>
     */
    public static String getNowTime(){
        String rtnValue = "";

        Date date = new Date();
        SimpleDateFormat df = new SimpleDateFormat("HHmmss");
        rtnValue = df.format(date);

        return rtnValue;
    }

    /**
     * 타임포멧 : yyyyMMddHHmmssSSS
     * @return
     */
    public static String getMillisecondTime(){
        String rtnValue = "";

        Date date = new Date();
        SimpleDateFormat df = new SimpleDateFormat("yyyyMMddHHmmssSSS");
        rtnValue = df.format(date);

        return rtnValue;
    }

    // 문자열 앞에 특정한 문자를 채워서 리턴한다.
    public static String getFillString( Object objTemp, String fillString, int len ){
        return getFillString(String.valueOf(objTemp), fillString, len, null);
    }

    // 문자열 앞에 특정한 문자를 채워서 리턴한다.
    public static String getFillString( Object objTemp, String fillString, int len, String option ){
        return getFillString(String.valueOf(objTemp), fillString, len, option);
    }

    // 문자열 앞에 특정한 문자를 채워서 리턴한다.
    public static String getFillString( String strTemp, String fillString, int len ){
        return getFillString(strTemp, fillString, len, null);
    }

    // 문자열 앞에 특정한 문자를 채워서 리턴한다.
    public static String getFillString( int intTemp, String fillString, int len ){
        String strTemp = String.valueOf(intTemp);
        return getFillString(strTemp, fillString, len, null);
    }

    // 문자열 앞에 특정한 문자를 채워서 리턴한다.
    public static String getFillString( String strTemp, String fillString, int len, String option ){
        if (strTemp == null)
            return "";

        if (strTemp.length() >= len)
            return strTemp;

        // 데이터 String 이 null 인 경우 공백 처리
        if (strTemp.equals("null"))
            strTemp = "";

        if (option == null)
            option = "RIGHT";

        option = option.toUpperCase();
        String rtnValue = "";

        if (option.equals("RIGHT")) {
            // 앞에 문자열을 채워서 리턴한다.
            len = len - strTemp.length();
            for (int i = 0; i < len; i++) {
                rtnValue += fillString;
            }
            rtnValue += strTemp;

        } else {
            // 뒤에 문자열을 채워서 리턴한다.
            rtnValue += strTemp;
            for (int i = strTemp.length(); i < len; i++) {
                rtnValue += fillString;
            }
        }

        return rtnValue;
    }

    // 숫자에 천단위로 콤마를 찍는다.
    public static String getNumberFormat( double number ){
        return getNumberFormat(String.valueOf(number));
    }

    // 숫자에 천단위로 콤마를 찍는다.
    public static String getNumberFormat( int number ){
        return getNumberFormat(String.valueOf(number));
    }

    // 숫자에 천단위로 콤마를 찍는다.
    public static String getNumberFormat( String number ){
        String rtnValue = "";
        double num = 0;

        if (number == null)
            return rtnValue;

        number = number.trim();
        if (number.equals(""))
            num = 0;
        else
            num = Double.parseDouble(number);

        DecimalFormat df = new DecimalFormat("#,##0");
        rtnValue = df.format(num);

        return rtnValue;
    }

    public static String maxDay_Before( int cnt ){

        Calendar cals = Calendar.getInstance();
        cals.add(Calendar.DATE, cnt);

        int tmp_days = cals.get(Calendar.DATE);
        int tmp_months = cals.get(Calendar.MONTH) + 1;
        String years = String.valueOf(cals.get(Calendar.YEAR));
        String days = "";
        String months = "";

        if (tmp_days >= 1 && tmp_days < 10)
            days = "0" + String.valueOf(tmp_days);
        else
            days = String.valueOf(tmp_days);

        if (tmp_months >= 1 && tmp_months < 10)
            months = "0" + String.valueOf(tmp_months);
        else
            months = String.valueOf(tmp_months);

        return years + months + days;
    }

    public String getDateNormal(){
        StringBuffer sb = new StringBuffer();
        Calendar cal;
        cal = Calendar.getInstance(new SimpleTimeZone(9 * 60 * 60 * 1000, "KST"));

        sb = sb.append(cal.get(Calendar.YEAR));
        sb = sb.append("-");
        sb = sb.append(reformat(cal.get(Calendar.MONTH) + 1));
        sb = sb.append("-");
        sb = sb.append(reformat(cal.get(Calendar.DATE)));
        return (sb.toString());
    }

    private String reformat( int n ){
        StringBuffer sb = new StringBuffer(2);

        if (n < 10) {
            sb.append("0" + String.valueOf(n));
        } else {
            sb.append(String.valueOf(n));
        }
        return (sb.toString());
    }

    /**
     * String을 받아서 숫자인지 판단후 리턴한다.
     * 
     * @param str
     * @return boolean
     * @auth Na Seung Bok
     */
    public static boolean isNumCheck( String str ) throws Exception{
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

    public static String nvlToStr( String str ) throws Exception{
        try {
            if (str == null) {
                str = "";
            }
        } catch (Exception e) {
            throw e;
        }
        return str;
    }

    public static String getMile( double w ){
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
     * 대상 날짜 문자열
     * @param sourcePattern
     * 원래 날짜 포맷
     * @param targetPattern
     * 변환할 날짜 포맷
     * @return 변환된 문자열
     */
    public static String changeFormat( String source, String sourcePattern, String targetPattern ){

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
    
    public static String printStackTraceToString(Exception ex){
    	StringWriter errors = new StringWriter();
    	
    	try{
    		ex.printStackTrace(new PrintWriter(errors));
    	}catch(Exception e){
    		// 무시..
    	}
        return errors.toString();
    }

	/**
	 * RESTFul 리소스 URI 를 리턴 한다.
	 *
	 * @param sourceUri
	 *            pathVariables 마크업이 포함된 uri
	 * @param pathVariables
	 *            pathVariables 마크업 변수를 치환할 변수 배열
	 * @return 리소스 uri 의 pathVariables 마크업이 실제 변수로 치환된 url
	 */
	public static String genUriWithPathVariables(String sourceUri, String... pathVariables) {
		String resultUri = null;
		if (pathVariables != null) {
			Matcher matcher = Pattern.compile(URI_REGEX).matcher(sourceUri);
			int matchedCount = 0;
			while (matcher.find()) {
				matchedCount++;
			}
			if (pathVariables.length == matchedCount) {
				resultUri = sourceUri;
				for (String pathVariable : pathVariables) {
					resultUri = resultUri.replaceFirst(URI_REGEX, pathVariable);
				}
			} else {
				throw new RuntimeException("path valiables count mismatched.\nsourceUri is " + sourceUri
						+ "\npathVariables is " + Arrays.toString(pathVariables));
			}
		} else {
			throw new RuntimeException("path valiable is null, abd sourceUri is " + sourceUri);
		}
		return resultUri;
	}

	/**
	 * RESTFul 리소스 URI 를 리턴 한다.
	 *
	 * @param uri
	 *            pathVariables 마크업이 포함된 uri
	 * @param pathVariables
	 *            pathVariables 마크업 변수를 치환할 변수 배열
	 * @return 리소스 uri 의 pathVariables 마크업이 실제 변수로 치환된 url
	 */
	public static String genAwareUriWithPathVariables(String uri, String... pathVariables) {
		String resultUri = uri;
		if (pathVariables != null) {
			Matcher matcher = Pattern.compile(URI_REGEX).matcher(uri);
			int matchedCount = 0;
			while (matcher.find()) {
				matchedCount++;
			}
			if (matchedCount > pathVariables.length) {
				throw new RuntimeException(
						String.format("path valiables count mismatched. uri is '%s' pathVariables is '%s'", uri,
								Arrays.toString(pathVariables)));
			} else {
				for (int i = 0; i < matchedCount; i++) {
					resultUri = resultUri.replaceFirst(URI_REGEX, pathVariables[i]);
				}
			}
		} else {
			throw new RuntimeException(String.format("path valiable is null, abd uri is '%s'", uri));
		}
		return resultUri;
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
			return (Long) value;
		} else if (value instanceof BigDecimal) {
			return ((BigDecimal) value).longValue();
		} else if (value instanceof BigInteger) {
			return ((BigInteger) value).longValue();
		} else if (value instanceof Long) {
			return ((Long) value).longValue();
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
			if (((Integer) val).intValue() < 1) {
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
			if (((Integer) val).intValue() == 1) {
				return true;
			}
		}
		return false;
	}
}
