// Compiler Theory and Design
// Mark Tasker

template <typename T>
class Symbols
{
public:
	void insert(char* lexeme, T entry);
	bool find(char* lexeme, T& entry);
	T get(char* lexeme);

private:
	map<string, T> symbols;
};

template <typename T>
void Symbols<T>::insert(char* lexeme, T entry)
{
	string name(lexeme);
	symbols[name] = entry;
}

template <typename T>
T Symbols<T>::get(char* lexeme)
{
	string name(lexeme);
	return symbols[name];
}

template <typename T>
bool Symbols<T>::find(char* lexeme, T& entry)
{
	string name(lexeme);
	typedef typename map<string, T>::iterator Iterator;
	Iterator iterator = symbols.find(name);
	bool found = iterator != symbols.end();
	if (found)
		entry = iterator->second;
	return found;
}