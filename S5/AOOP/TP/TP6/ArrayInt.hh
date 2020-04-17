#pragma once
#include <vector>
#include <iostream>
class ArrayInt{
	public:
		using indice=signed int;
		ArrayInt(indice imin, indice imax);
		indice iMax() const {return iMax; }
		indice iMin() const {return iMin; }
		void set(indice i, int v);
		int at(indice i) const;
		int operator [](indice i) const;
		ArrayInt & operator = (ArrayInt const & a)=default;
		bool operator==(ArrayInt const & a)const;

	private:
		std::vector<int> contenu;
		signed int imin;
		signed int imax;
};

class ExceptionArrayInt: public std::exception{
	public:
		ExceptionArrayInt(std::string const &m, ArrayInt::indice i):
			exception(),message(m),indice(i){}
		char const * what() const noexcept override;
	private:
		std::string message;
		ArrayInt::indice ind;
};

std::ostream & operator==(,std::ostream & os,ArrayInt const & a);
