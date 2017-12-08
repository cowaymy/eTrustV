package com.coway.trust.util;

import java.beans.PropertyDescriptor;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.sql.Timestamp;
import java.util.*;

import org.springframework.beans.BeanUtils;

import com.coway.trust.AppConstants;
import com.coway.trust.cmmn.exception.ApplicationException;

public final class BeanConverter {
	private BeanConverter() {
	}

	/**
	 * @param name
	 * @param ignoreProperties
	 * @return
	 */
	static private boolean ignoreProperty(String name, String... ignoreProperties) {
		for (String propName : ignoreProperties) {
			if (name.equals(propName)) {
				// System.out.println( "ignoreProperty ----- " + name );
				return true;
			}
		}
		return false;
	}

	/**
	 * Java 오브젝트 객체를 파라미터로, Map<K,V> 컬렉션 맵으로 변환 한다.
	 * 
	 * @param bean
	 *            소스 객체
	 * @return 컬렉션 맵 java.util.Map
	 */
	static public Map<String, Object> toMap(Object bean) {
		return toMap(bean, "class", "blob_body");
	}

	/**
	 * Java 오브젝트 객체를 파라미터로, Map<K,V> 컬렉션 맵으로 변환 한다.
	 * 
	 * @param bean
	 *            소스 객체
	 * @param ignoreProperties
	 *            무시할 속성
	 * @return 컬렉션 맵 java.util.Map
	 */
	static public Map<String, Object> toMap(Object bean, String... ignoreProperties) {
		if (bean == null) {
			return new HashMap<>();
		}
		if (ignoreProperties == null) {
			ignoreProperties = new String[] { "class", "blob_body" };
		}
		Map<String, Object> row = new HashMap<>();
		try {
			PropertyDescriptor[] descriptors = BeanUtils.getPropertyDescriptors(bean.getClass());
			for (PropertyDescriptor descriptor : descriptors) {
				String name = descriptor.getName();
				if (ignoreProperty(name, ignoreProperties)) {
					continue;
				}
				Method getter = descriptor.getReadMethod();
				if (getter == null) {
					continue;
				}
				String getterName = getter.getName();
				Object value = getter.invoke(bean, new Object[] {});
				if (getterName.startsWith("get") || getterName.startsWith("is")) {
					row.put(name, value);
				}
			}
			return row;
		} catch (Exception e) {
			throw new ApplicationException(e);
		}
	}

	static private void setterDouble(Method setter, Object bean, Class<?> paramType, Object value)
			throws IllegalAccessException, IllegalArgumentException, InvocationTargetException {
		if (paramType == Integer.class) {
			setter.invoke(bean, new Double((Integer) value));
		} else if (paramType == Float.class) {
			setter.invoke(bean, ((Float) value).doubleValue());
		} else if (paramType == Long.class) {
			setter.invoke(bean, ((Long) value).doubleValue());
		} else if (paramType == BigDecimal.class) {
			setter.invoke(bean, ((BigDecimal) value).doubleValue());
		} else if (paramType == BigInteger.class) {
			setter.invoke(bean, ((BigInteger) value).doubleValue());
		} else if (paramType == String.class) {
			setter.invoke(bean, Double.parseDouble((String) value));
		} else {
			setter.invoke(bean, value);
		}
	}

	static private void setterInteger(Method setter, Object bean, Class<?> paramType, Object value)
			throws IllegalAccessException, IllegalArgumentException, InvocationTargetException {
		if (paramType == Double.class) {
			setter.invoke(bean, ((Double) value).intValue());
		} else if (paramType == Float.class) {
			setter.invoke(bean, ((Float) value).intValue());
		} else if (paramType == Long.class) {
			setter.invoke(bean, ((Long) value).intValue());
		} else if (paramType == BigDecimal.class) {
			setter.invoke(bean, ((BigDecimal) value).intValue());
		} else if (paramType == BigInteger.class) {
			setter.invoke(bean, ((BigInteger) value).intValue());
		} else if (paramType == String.class) {
			setter.invoke(bean, Integer.parseInt((String) value));
		} else if (paramType == Boolean.class) {
			if (((Boolean) value)) {
				setter.invoke(bean, 1);
			} else {
				setter.invoke(bean, 0);
			}
		} else {
			setter.invoke(bean, value);
		}
	}

	static private void setterFloat(Method setter, Object bean, Class<?> paramType, Object value)
			throws IllegalAccessException, IllegalArgumentException, InvocationTargetException {
		if (paramType == Double.class) {
			setter.invoke(bean, ((Double) value).floatValue());
		} else if (paramType == Integer.class) {
			setter.invoke(bean, ((Integer) value).floatValue());
		} else if (paramType == Long.class) {
			setter.invoke(bean, ((Long) value).floatValue());
		} else if (paramType == BigDecimal.class) {
			setter.invoke(bean, ((BigDecimal) value).floatValue());
		} else if (paramType == BigInteger.class) {
			setter.invoke(bean, ((BigInteger) value).floatValue());
		} else if (paramType == String.class) {
			setter.invoke(bean, Float.parseFloat((String) value));
		} else {
			setter.invoke(bean, value);
		}
	}

	static private void setterLong(Method setter, Object bean, Class<?> paramType, Object value)
			throws IllegalAccessException, IllegalArgumentException, InvocationTargetException {
		if (paramType == Integer.class) {
			setter.invoke(bean, ((Integer) value).longValue());
		} else if (paramType == Double.class) {
			setter.invoke(bean, ((Double) value).longValue());
		} else if (paramType == Float.class) {
			setter.invoke(bean, ((Float) value).longValue());
		} else if (paramType == BigDecimal.class) {
			setter.invoke(bean, ((BigDecimal) value).longValue());
		} else if (paramType == BigInteger.class) {
			setter.invoke(bean, ((BigInteger) value).longValue());
		} else if (paramType == String.class) {
			setter.invoke(bean, Long.parseLong((String) value));
		} else {
			setter.invoke(bean, value);
		}
	}

	static private void setterBoolean(Method setter, Object bean, Class<?> paramType, Object value)
			throws IllegalAccessException, IllegalArgumentException, InvocationTargetException {
		int v = 0;
		if (paramType == Integer.class) {
			v = (Integer) value;
		} else if (paramType == Double.class) {
			v = ((Double) value).intValue();
		} else if (paramType == Float.class) {
			v = ((Float) value).intValue();
		} else if (paramType == BigDecimal.class) {
			v = ((BigDecimal) value).intValue();
		} else if (paramType == BigInteger.class) {
			v = ((BigInteger) value).intValue();
		} else if (paramType == String.class) {
			setter.invoke(bean, Boolean.getBoolean((String) value));
		} else {
			setter.invoke(bean, Boolean.getBoolean((String) value));
		}
		if (v == 1) {
			setter.invoke(bean, Boolean.TRUE);
		} else {
			setter.invoke(bean, Boolean.FALSE);
		}
	}

	static private void setterDate(Method setter, Object bean, Class<?> paramType, Object value)
			throws IllegalAccessException, IllegalArgumentException, InvocationTargetException {
		if (paramType == Timestamp.class) {
			setter.invoke(bean, new Date(((Timestamp) value).getTime()));
		} else if (paramType == Long.class) {
			setter.invoke(bean, new Date((Long) value));
		}
		// else if ( paramType == Double.class )
		// {
		// ( (Double) value ).longValue();
		// }
		// else if ( paramType == Float.class )
		// {
		// ( (Float) value ).longValue();
		// }
		// else if ( paramType == BigDecimal.class )
		// {
		// ( (BigDecimal) value ).longValue();
		// }
		// else if ( paramType == BigInteger.class )
		// {
		// ( (BigInteger) value ).longValue();
		// }
		// else if ( paramType == String.class )
		// {
		// Long.parseLong( (String) value );
		// }
		else {
			setter.invoke(bean, new Date(Long.parseLong((String) value)));
		}
	}

	/**
	 * Map<K, V> 맵 컬렉션 객체를 파라미터로 선언된 클래스 타입 <T> 로 변환 한다.
	 *
	 * @param row
	 *            Map<K,V>
	 * @param clazz
	 *            T Java 객체로 변환할 클래스 타입
	 * @return T 변환된 자바 클래스
	 * @throws Exception
	 */
	static public <T> T toBean(Map<String, Object> row, Class<T> clazz) {
		if (row == null) {
			throw new ApplicationException(AppConstants.FAIL, "Can not convert to target class. Source object is null");
		}
		try {
			T bean = clazz.newInstance();
			PropertyDescriptor[] props = BeanUtils.getPropertyDescriptors(clazz);
			for (PropertyDescriptor desc : props) {
				final String name = desc.getName();
				Object value = row.get(name);
				Method setter = desc.getWriteMethod();
				if (value != null && setter != null) {
					Class<?> valueType = value.getClass();
					Class<?> parameterType = setter.getParameterTypes()[0];
					// System.out.printf( "==========\n name : %s valueType: %s value: %s, setterType: %s\n", name,
					// valueType.getTypeName(), value.toString(),
					// parameterType.getTypeName() );
					if (valueType == parameterType) {
						setter.invoke(bean, value);
					} else {
						if (parameterType == String.class) {
							setter.invoke(bean, (String) value);
						} else if (parameterType == Double.class) {
							setterDouble(setter, bean, valueType, value);
						} else if (parameterType == Integer.class) {
							setterInteger(setter, bean, valueType, value);
						} else if (parameterType == Float.class) {
							setterFloat(setter, bean, valueType, value);
						} else if (parameterType == Long.class) {
							setterLong(setter, bean, valueType, value);
						} else if (parameterType == Boolean.class) {
							setterBoolean(setter, bean, valueType, value);
						} else if (parameterType == Date.class) {
							setterDate(setter, bean, valueType, value);
						} else if (parameterType.getName().equals("int")) {
							setterInteger(setter, bean, valueType, value);
						} else {
							setter.invoke(bean, value);
						}
					}
				}
			}
			return bean;
		} catch (Exception e) {
			e.printStackTrace();
			throw new ApplicationException(e);
		}
	}

	/**
	 * List<Map<K, V>> 리스트 컬렉션 객체를 파라미터로 선언된 클래스 타입 <T>를 통해 리스트 컬렉션 List<T>로 변환 한다.
	 *
	 * @param rows
	 *            List<Map<K,V>> 컬렉션
	 * @param clazz
	 *            변환될 클래스 타입
	 * @return List<T> 컬렉션 객체
	 * @throws Exception
	 */
	static public <M extends Map<String, Object>, T> List<T> toBeans(List<M> rows, Class<T> clazz) throws Exception {
		if (rows == null) {
			return Collections.emptyList();
		}
		List<T> list = new ArrayList<>();
		for (M row : rows) {
			T bean = toBean(row, clazz);
			list.add(bean);
		}
		return list;
	}

	/**
	 * source 객체를 타겟 clazz 객체로 복제 하고, 복제된 타겟 객체를 리턴 한다.
	 * 
	 * @param source
	 *            소스 오브젝트 객체
	 * @param clazz
	 *            리턴 오브젝트 타입
	 * @return 리턴 오브젝트
	 * @throws Exception
	 */
	static public <T> T copyProperties(Object source, Class<T> clazz) throws Exception {
		if (source == null) {
			return null;
		}
		T target = BeanUtils.instantiate(clazz);
		BeanUtils.copyProperties(source, target);
		return target;
	}

	/**
	 * 타겟 객체의 속성값을 source 객체의 속성들로 copy 합니다.
	 * 
	 * @param source
	 * @param target
	 * @throws Exception
	 */
	static public void copyProperties(Object source, Object target) throws Exception {
		if (source == null || target == null) {
			throw new ApplicationException(AppConstants.FAIL, "Source or Target object is null.");
		}
		BeanUtils.copyProperties(source, target);
	}

	/**
	 * source 객체를 타겟 clazz 객체로 복제 하고, 복제된 타겟 객체를 리턴 한다.
	 * 
	 * @param source
	 *            소스 오브젝트 객체
	 * @param clazz
	 *            리턴 오브젝트 타입
	 * @param ignoreProperties
	 *            무시될 속성 명 배열
	 * @return 리턴 오브젝트
	 * @throws Exception
	 */
	static public <T> T copyProperties(Object source, Class<T> clazz, String... ignoreProperties) throws Exception {
		if (source == null) {
			return null;
		}
		T target = BeanUtils.instantiate(clazz);
		BeanUtils.copyProperties(source, target, ignoreProperties);
		return target;
	}
}
